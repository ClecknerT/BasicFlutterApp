//2022-07-31T00:00:00.000Z
var express = require("express");
// var moment = require("moment");
var http = require('http');
var request = require('request');
var fs = require('fs');
var Q = require('q');
//var cors = require('cors');

var app = express();
var port = process.env.PORT || 7000;
var baseDir ='https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl';

// cors config
// var whitelist = ['https://localhost:7000/latest_wx'];

var corsOptions = {
	origin: function(origin, callback){
		var originIsWhitelisted = whitelist.indexOf(origin) !== -1;
		callback(null, originIsWhitelisted);
	}
};
var windRetries = 0;
// var wxRetries = 0;
const epoch = new Date().getTime().toString();
var date = new Date();
var hour = date.getUTCHours();
var month = date.getUTCMonth() + 1;
var year = date.getUTCFullYear();
var day = date.getUTCDate();
var roundedHour = '';
var newHour = '';
var newMonth = '';
var newDay = '';
if (hour >= 0 && hour < 6 ){
	// roundedHour = 0;
	roundedHour = '00';
} else if (hour >= 6 && hour < 12 ){
	// roundedHour = 6;
	roundedHour = '06';
} else if (hour >= 12 && hour < 18 ){
	// roundedHour = 12;
	roundedHour = '12';
} else if (hour >= 18 ){
	// roundedHour = 18;
	roundedHour = '18';
}
// roundedHour = '18'
console.log('hour: '+hour);
console.log('roundedHour: '+roundedHour);

if (month > 0 || month <= 9 ){
	newMonthStr = '0'+month.toString();
} else {
	newMonthStr = month.toString();
}
console.log('month: '+month);
console.log('newMonthStr: '+newMonthStr);

if (day >= 0 && day <= 9 ){
	newDayStr = '0'+day.toString();
} else {
	newDayStr = day.toString();
}
console.log('day: '+day);
console.log('newDayStr: '+newDayStr);
var stamp =  year.toString()+newMonthStr+newDayStr;
// var stamp =  '20220725';
console.log('stamp: '+stamp);

app.listen(port, function(err){
	// console.log("running server on port "+ port);
});

app.use(express.static('public'));

//app.get('/', cors(corsOptions), function(req, res){
app.get('/', function(req, res){
	//un(day, hour, month, year, stamp, roundedHour, newDay, newMonth);
    res.send('hello wind-js-server.. <br>go to /latest for wind data..<br> ');
});

//app.get('/alive', cors(corsOptions), function(req, res){
app.get('/alive', function(req, res){
	res.send('wind-js-server is alive');
});

//app.get('/latest', cors(corsOptions), function(req, res){
app.get('/latest', function(req, res){
	console.log('getting latest wind')
	run(day, hour, month, year, stamp, roundedHour, newDay, newMonth);
	/**
	 * Find and return the latest available 6 hourly pre-parsed JSON data for wind
	 *
	 * @param targetMoment {Object} UTC moment
	 */
	function sendLatest(stamp){

		// var stamp = moment(targetMoment).format('YYYYMMDD');
		var fileName = __dirname +"/json-data/wind.json";

		res.setHeader('Content-Type', 'application/json');
		res.sendFile(fileName, {}, function (err) {
			if (err) {
				console.log(stamp +'latest doesnt exist yet, trying previous interval..');
				// sendLatest(epoch, stamp);
			}
		});
	}

	sendLatest(stamp);

});

//app.get('/latest_wx', cors(corsOptions), function(req, res){
// app.get('/latest_wx', function(req, res){

// 	/**
// 	 * Find and return the latest available 6 hourly pre-parsed JSON data for weather
// 	 *
// 	 * @param targetMoment {Object} UTC moment
// 	 */
// 	function sendLatest(stamp){

// 		// var stamp = moment(targetMoment).format('YYYYMMDD');
// 		var fileName = __dirname +"/json-wx-data/wx.json";

// 		res.setHeader('Content-Type', 'application/json');
// 		res.sendFile(fileName, {}, function (err) {
// 			if (err) {
// 				console.log(stamp +'latest_wx doesnt exist yet, trying previous interval..');
// 				// sendLatest(moment(targetMoment).subtract(1, 'day'));
// 			}
// 		});
// 	}

// 	sendLatest(stamp);

// });

//app.get('/nearest', cors(corsOptions), function(req, res, next){
app.get('/nearest', function(req, res, next){

	var time = req.query.timeIso;
	var limit = req.query.searchLimit;
	var searchForwards = false;

	/**
	 * Find and return the nearest available 6 hourly pre-parsed JSON data
	 * If limit provided, searches backwards to limit, then forwards to limit before failing.
	 *
	 * @param targetMoment {Object} UTC moment
	 */
	function sendNearestTo(stamp){

		// if( limit && Math.abs( moment.utc(time).diff(targetMoment, 'days'))  >= limit) {
		// 	if(!searchForwards){
		// 		searchForwards = true;
		// 		sendNearestTo(moment(targetMoment).add(limit, 'days'));
		// 		return;
		// 	}
		// 	else {
		// 		return next(new Error('No data within searchLimit'));
		// 	}
		// }

		// var stamp = moment(targetMoment).format('YYYYMMDD');
		var fileName = __dirname +"/json-data/"+ stamp +".json";

		res.setHeader('Content-Type', 'application/json');
		res.sendFile(fileName, {}, function (err) {
			if(err) {
				// var nextTarget = searchForwards ? moment(targetMoment).add(1, 'day') : moment(targetMoment).subtract(1, 'day');
				// sendNearestTo(nextTarget);
			}
		});
	}

	// if(time && moment(time).isValid()){
		sendNearestTo(stamp);
	// }
	// else {
	// 	return next(new Error('Invalid params, expecting: timeIso=ISO_TIME_STRING'));
	// }

});

/**
 *
 * Ping for new data every 15 mins
 *
 */
setInterval(function(){
	run(day, hour, month, year, stamp, roundedHour, newDay, newMonth);
	// run_wx(epoch,stamp,roundedHour, month, day,year);
}, 900000);

/**
 *
 * @param targetMoment {Object} moment to check for new data
 */
function run(day, hour, month, year, stamp, roundedHour, newDay, newMonth){
    console.log("run: "+epoch+" roundedHour: "+roundedHour);
    /* get wind data from noaa */
	getWindGribData(day, hour, month, year, stamp, roundedHour, newDay, newMonth).then(function(response){
		if(response.stamp){
			convertWindGribToJson(response.stamp, response.epoch);
		}
	});
}

// function run_wx(epoch,stamp,roundedHour, month, day,year){
//     console.log("Get WX");
//     /* get misc weather data */
// 	getWxGribData(epoch,stamp,roundedHour, month, day,year).then(function(response){
// 		if(response.stamp){
// 			convertWxGribToJson(response.stamp, response.epoch);
// 		}
// 	});
// }

/**
 *
 * Finds and returns the latest 6 hourly wind GRIB2 data from NOAAA
 *
 * @returns {*|promise}
 */
function getWindGribData(day, hour, month, year, stamp, roundedHour, newDay, newMonth){
	var day = day;  
	var hour =hour;
	var month = month; 
	var year = year;
	var stamp = stamp;
	var roundedHour =roundedHour;
	var newMonth = '';
	var newDay = '';
	var deferred = Q.defer();
    console.log("getWindGribData epoch: "+epoch+" roundedHour: "+roundedHour);

	function runQuery(day, hour, month, year, stamp, roundedHour, newDay, newMonth){
		console.log('runQuery day2: '+day);
			console.log('runQuery hour2: '+hour);
			console.log('runQuery month2: '+month);
			console.log('runQuery roundedHour2: '+roundedHour);
			console.log('runQuery stamp2: '+stamp);
			console.log('runQuery newDay2: '+newDay);
			console.log('runQuery newMonth2: '+newMonth);
		var urlx =  'https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t'+roundedHour+'z.pgrb2.1p00.f000&lev_10_m_above_ground=on&lev_mean_sea_level=on&lev_surface=on&var_PRMSL=on&var_TMP=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.'+stamp + '%2F'+ roundedHour +'%2Fatmos';
		// console.log('urlx: '+urlx);
		request.get({
			url: 'https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t'+roundedHour+'z.pgrb2.1p00.f000&lev_10_m_above_ground=on&lev_mean_sea_level=on&lev_surface=on&var_PRMSL=on&var_TMP=on&var_UGRD=on&var_VGRD=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.'+stamp + '%2F'+ roundedHour +'%2Fatmos',
			// qs: {
			// 	file: 'gfs.t'+ roundedHour +'z.pgrb2.1p00.f000',
			// 	lev_10_m_above_ground: 'on',
			// 	lev_surface: 'on',
            //     lev_mean_sea_level:'on',
			// 	var_TMP: 'on',
			// 	var_UGRD: 'on',
			// 	var_VGRD: 'on', 
            //     var_PRMSL: 'on',
			// 	leftlon: 0,
			// 	rightlon: 360,
			// 	toplat: 90,
			// 	bottomlat: -90,
			// 	dir: '/gfs.'+stamp + "/"+roundedHour+"/atmos"
			// }

		}).on('error', function(err){
			console.log('wind response 1 '+response.statusCode + ' | '+stamp);
			console.log('day1: '+day);
			console.log('hour1: '+hour);
			console.log('month1: '+month);
			console.log('roundedHour1: '+roundedHour);
			console.log('stamp1: '+stamp);
			console.log('newDay1: '+newDay);
			console.log('newMonth1: '+newMonth);
			console.log('response.statusCode: '+response.statusCode);
			if(response.statusCode != 200){
				console.log('get wind err 2:' );
				windRetries= windRetries +1;
				if (windRetries <= 5){
					if (roundedHour =='00'){
						roundedHour='18';
						day = day - 1;
						if (day == 0 ){
							if(month == 2 || month==4 || month==11 || month==1 || month==4 || month==6 || month==9){
								newDay = '31';
								day=31;
							}else if (month == 3 ){
								newDay = '28';
								day=28;
							}else if (month == 5 || month==7 || month==10 || month==12 ){
								newDay = '30';
								day=30;
							}
							var month = month -1;
							if(month.toString().length==1) { 
								if(month == 0){
									month = 12;
									newMonth = '12';
									year = year -1;
								} else {
									newMonth='0'+nMonth.toString()
								}
							}
							stamp =  year.toString()+newMonth+newDay;
						} else{
							// console.log('adding a 0 month: '+month);
							// console.log('month.length: '+month.toString().length);
							if(month.toString().length==1) { 
								// console.log('adding a 0');
								newMonth='0'+nMonth
							}else{
								newMonth=month.toString();
							};
							if(day.toString().length ==1){
								newDay = '0'+day.toString();
							}else{
								newDay = day.toString();
							}
						}
					} else if(roundedHour =='06'){roundedHour='00'}
					else if(roundedHour =='12'){roundedHour='06'}
					else if(roundedHour =='18'){roundedHour='12'}
					// console.log('day3: '+day);
					// console.log('newDay3: '+newDay);
					// console.log('roundedHour3: '+roundedHour);
					// console.log('month3: '+month);
					// console.log('newMonth3: '+newMonth);
					// console.log('stamp3: '+stamp);
	
					runQuery(day, hour, month, year, stamp, roundedHour, newDay, newMonth);
				} else {
					console.log('Could not get wind');
				}
			}
		}).on('response', function(response) {
			// console.log('wind response 1 '+response.statusCode + ' | '+stamp);
			// console.log('day2: '+day);
			// console.log('hour2: '+hour);
			// console.log('month2: '+month);
			// console.log('roundedHour2: '+roundedHour);
			// console.log('newDay2: '+newDay);
			// console.log('newMonth2: '+newMonth);
			if(response.statusCode != 200){
				console.log('get wind err 2:' );
				windRetries= windRetries +1;
				if (windRetries <= 5){
					if (roundedHour =='00'){
						roundedHour='18';
						day = day - 1;
						if (day == 0 ){
							if(month == 2 || month==4 || month==11 || month==1 || month==4 || month==6 || month==9){
								newDay = '31';
								day=31;
							}else if (month == 3 ){
								newDay = '28';
								day=28;
							}else if (month == 5 || month==7 || month==10 || month==12 ){
								newDay = '30';
								day=30;
							}
							var month = month -1;
							if(month.toString().length==1) { 
								if(month == 0){
									month = 12;
									newMonth = '12';
									year = year -1;
								} else {
									newMonth='0'+nMonth.toString()
								}
							}
							stamp =  year.toString()+newMonth+newDay;
						} else{
							// console.log('adding a 0 month: '+month);
							// console.log('month.length: '+month.toString().length);
							if(month.toString().length==1) { 
								// console.log('adding a 0');
								newMonth='0'+nMonth
							}else{
								newMonth=month.toString();
							};
							if(day.toString().length ==1){
								newDay = '0'+day.toString();
							}else{
								newDay = day.toString();
							}
						}
					} else if(roundedHour =='06'){roundedHour='00'}
					else if(roundedHour =='12'){roundedHour='06'}
					else if(roundedHour =='18'){roundedHour='12'}
					// console.log('day3: '+day);
					// console.log('newDay3: '+newDay);
					// console.log('roundedHour3: '+roundedHour);
					// console.log('month3: '+month);
					// console.log('newMonth3: '+newMonth);
					// console.log('stamp3: '+stamp);
	
					runQuery(day, hour, month, year, stamp, roundedHour, newDay, newMonth);
				} else {
					console.log('Could not get wind');
				}
			}
			else {
				console.log('piping ' + stamp);
				checkPath('grib-data', true);
				// console.log('checkPath ');
				var file = fs.createWriteStream(`grib-data/wind.f000`);
				// console.log('file ');
				response.pipe(file);
				// console.log('pipe ');
				file.on('finish', function() {
					// console.log('file ');
					file.close();
					deferred.resolve({stamp: stamp, targetMoment: epoch});
				});
			}
		});

	}

	runQuery(day, hour, month, year, stamp, roundedHour, newDay, newMonth);
	return deferred.promise;
}

function convertWindGribToJson(){

	// mk sure we've got somewhere to put output
	checkPath('json-data', true);

	var exec = require('child_process').exec, child;
	var x = `converter/bin/grib2json --data --output json-data/wind.json --names --compact grib-data/wind.f000`;
	child = exec(x,
		{maxBuffer: 500*1024},
		function (error, stdout, stderr){

			if(error){
				console.log('exec error: ' + error);
			}

			else {
				// console.log("converted..");

				// don't keep raw grib data
				exec('rm grib-data/*');

				// if we don't have older stamp, try and harvest one
				// var prevMoment = moment(targetMoment).subtract(6, 'hours');
				// var prevStamp = prevMoment.format('YYYYMMDD') + roundHours(prevMoment.hour(), 6);

				// if(!checkPath('json-data/'+ prevStamp +'.json', false)){

				// 	console.log("attempting to harvest older wind data "+ stamp);
				// 	run(prevMoment);
				// }

				// else {
				// 	console.log('got older, no need to harvest wind further');
				// }
			}
		});
}

/**
 *
 * Finds and returns the latest 6 hourly wx GRIB2 data from NOAAA
 *
 * @returns {*|promise}
 */
// function getWxGribData(epoch,stamp,roundedHour, month, day,year){

// 	var deferred = Q.defer();

// 	function runQuery(epoch,stamp,roundedHour, month, day,year){
// 		request.get({
// 			url: 'https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t'+ roundedHour +'z.pgrb2.1p00.f000&var_CWAT=on&var_PRMSL=on&var_PWAT=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.'+stamp+'%2F'+ roundedHour +'%2Fatmos',
// 			// qs: {
// 			// 	file: 'gfs.t'+ roundedHour +'z.pgrb2.1p00.f000',
// 			// 	var_PRMSL: 'on',
// 			// 	var_CWAT: 'on',
// 			// 	var_PWAT: 'on',
// 			// 	leftlon: 0,
// 			// 	rightlon: 360,
// 			// 	toplat: 90,
// 			// 	bottomlat: -90,
// 			// 	dir: '/gfs.'+stamp + "/"+roundedHour+"/atmos"
// 			// }

// 		}).on('error', function(err){
// 			console.log('get wx err: '+err);
// 			wxRetries= wxRetries +1;
// 			if (wxRetries <= 4){
// 				if (roundedHour =='00'){
// 					roundHour='18';
// 					day = day - 1;
// 					if (day == 0 ){
// 						if(month == 2 || month==4 || month==11 || month==1 || month==4 || month==6 || month==9){
// 							newDay = '31';
// 							day=31;
// 						}else if (month == 3 ){
// 							newDay = '28';
// 							day=28;
// 						}else if (month == 5 || month==7 || month==10 || month==12 ){
// 							newDay = '30';
// 							day=30;
// 						}
// 						var nMonth = month -1;
// 						if(nMonth.length==1) {newMonth='0'+nMonth.toString()};
// 						} else{newMonth=month.toString()}
// 						stamp =  year.toString()+newMonth.toString()+newDay.toString();
// 					}
// 					if(roundedHour =='06'){roundedHour='00'}
// 					if(roundedHour =='12'){roundedHour='06'}
// 					if(roundedHour =='18'){roundedHour='12'}
// 				runQuery(epoch,stamp,roundedHour, month, day,year);
// 			}
// 		}).on('response', function(response) {
// 			console.log('response '+response.statusCode + ' | '+stamp);
// 			if(response.statusCode != 200){
// 				console.log('response '+response.statusCode + response.body );
// 				if (roundedHour =='00'){
// 					roundHour='18';
// 					day = day - 1;
// 					if (day == 0 ){
// 						if(month == 2 || month==4 || month==11 || month==1 || month==4 || month==6 || month==9){
// 							newDay = '31';
// 							day=31;
// 						}else if (month == 3 ){
// 							newDay = '28';
// 							day=28;
// 						}else if (month == 5 || month==7 || month==10 || month==12 ){
// 							newDay = '30';
// 							day=30;
// 						}
// 						var nMonth = month -1;
// 						if(nMonth.length==1) {newMonth='0'+nMonth.toString()};
// 						} else{newMonth=month.toString()}
// 						stamp =  year.toString()+newMonth.toString()+newDay.toString();
// 					}
// 					if(roundedHour =='06'){roundedHour='00'}
// 					if(roundedHour =='12'){roundedHour='06'}
// 					if(roundedHour =='18'){roundedHour='12'}
// 				runQuery(epoch,stamp,roundedHour, month, day,year);
// 			}
// 			else {
// 				// don't rewrite stamps
// 				if(!checkPath('json-wx-data/'+ stamp +'.json', false)) {
// 					console.log('wx piping ' + stamp);
// 					// mk sure we've got somewhere to put output
// 					checkPath('grib-wx-data', true);
// 					// pipe the file, resolve the valid time stamp
// 					var file = fs.createWriteStream(`grib-wx-data/wx.f000`);
// 					response.pipe(file);
// 					file.on('finish', function() {
// 						file.close();
// 						deferred.resolve({stamp: stamp, targetMoment: epoch});
// 					});
// 				}
// 				else {
// 					console.log('already have wx '+ stamp +', not looking further');
// 					deferred.resolve({stamp: false, targetMoment: false});
// 				}
// 			}
// 		});

// 	}

// 	runQuery(epoch,stamp,roundedHour, month, day,year);
// 	return deferred.promise;
// }


// function convertWxGribToJson(epoch,stamp,roundedHour, month, day,year){

// 	// mk sure we've got somewhere to put output
// 	checkPath('json-wx-data', true);

// 	var exec = require('child_process').exec, child;

// 	child = exec(`converter/bin/grib2json --data --output json-wx-data/wx.json --names --compact grib-wx-data/wx.f000`,
// 		{maxBuffer: 500*1024},
// 		function (error, stdout, stderr){

// 			if(error){
// 				console.log('exec error: ' + error);
// 			}

// 			else {
// 				console.log("converted..");

// 				// don't keep raw grib data
// 				exec('rm grib-wx-data/*');

// 				// if we don't have older stamp, try and harvest one
// 				// var prevMoment = moment(targetMoment).subtract(6, 'hours');
// 				// var prevStamp = prevMoment.format('YYYYMMDD') + roundHours(prevMoment.hour(), 6);

// 				// if(!checkPath('json-wx-data/'+ prevStamp +'.json', false)){

// 				// 	console.log("attempting to harvest older wx data "+ stamp);
// 				// 	run_wx(prevMoment);
// 				// }

// 				// else {
// 				// 	console.log('got older, no need to harvest wx further');
// 				// }
// 			}
// 		});
// }

/**
 *
 * Round hours to expected interval, e.g. we're currently using 6 hourly interval
 * i.e. 00 || 06 || 12 || 18
 *
 * @param hours
 * @param interval
 * @returns {String}
 */
function roundHours(hours, interval){
	if(interval > 0){
		var result = (Math.floor(hours / interval) * interval);
		return result < 10 ? '0' + result.toString() : result;
	}
}

/**
 * Sync check if path or file exists
 *
 * @param path {string}
 * @param mkdir {boolean} create dir if doesn't exist
 * @returns {boolean}
 */
function checkPath(path, mkdir) {
    try {
	    fs.statSync(path);
	    return true;

    } catch(e) {
        if(mkdir){
	        fs.mkdirSync(path);
        }
	    return false;
    }
}

// init harvest
run(day, hour, month, year, stamp, roundedHour, newDay, newMonth);
// run_wx(epoch,stamp,roundedHour, month, day,year);
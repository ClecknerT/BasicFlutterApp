//var mapmargin = 0;
//var mapHeight = (jQuery(window).height() * 0.80) - mapmargin;
//jQuery('#map').css("height", mapHeight);
//jQuery(window).on("resize", resize);

function resize(){
    var mapmargin = 0;
    var mapHeight = (jQuery(window).height() * 1.00) - mapmargin;
    jQuery('#map').css("height", mapHeight);    
    jQuery('#map').css("margin-top", mapmargin);
}
resize();

function initDemoMap(){

    // var Esri_WorldImagery = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
    //     attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, ' +
    //     'AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
    // });


    var Esri_DarkGreyCanvas = L.tileLayer(
        "http://{s}.sm.mapstack.stamen.com/" +
        "(toner-lite,$fff[difference],$fff[@23],$fff[hsl-saturation@20])/" +
        "{z}/{x}/{y}.png",
        {
            attribution: 'Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ, TomTom, Intermap, iPC, USGS, FAO, ' +
            'NPS, NRCAN, GeoBase, Kadaster NL, Ordnance Survey, Esri Japan, METI, Esri China (Hong Kong), and the GIS User Community'
        }
    );
/*
    var CartoDB_DarkMatterNoLabels = L.tileLayer('http://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}.png', {
	    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    	subdomains: 'abcd',
	    maxZoom: 19
    });


    var Stamen_TonerBackground = L.tileLayer('http://stamen-tiles-{s}.a.ssl.fastly.net/toner-background/{z}/{x}/{y}.{ext}', {
	    attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
	    subdomains: 'abcd',
	    minZoom: 0,
	    maxZoom: 20,
	    ext: 'png'
    });
*/
    // var Esri_WorldGrayCanvas = L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}', {
	//     attribution: 'Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ',
	//     maxZoom: 16
    // });

    var baseLayers = {
        // "Satellite": Esri_WorldImagery,
        "Grey Canvas": Esri_DarkGreyCanvas,
        // "World Gray": Esri_WorldGrayCanvas
    };

    var map = L.map('map', {
        center:[0,0],
        minZoom: 2,
        maxZoom: 5,
        zoom: 2,
        worldCopyJump: true,
        layers: [ Esri_DarkGreyCanvas ]
    });

    var layerControl = L.control.layers(baseLayers);
 
/*
    map.setMaxBounds([
        [-1080, 85],
        [1080, -85]
    ]);
*/
        
    layerControl.addTo(map);

    return {
        map: map,
        layerControl: layerControl
    };
}

// demo map
var mapStuff = initDemoMap();
var map = mapStuff.map;
var layerControl = mapStuff.layerControl;
var handleError = function(err){
    console.log('handleError...');
    console.log(err);
};


/* write a table of earthquakes to map page */
function writeQuakeTable(quakes, tableId)
{
    var tab = '';
    var feat = quakes.features;

    for (var i = 0; i < feat.length; i++) {
        if (feat[i].geometry.coordinates[2] < 90 && feat[i].properties.mag >= 4.5 || 
            feat[i].geometry.coordinates[2] >= 90 && feat[i].properties.mag >= 4.0) {
            if (feat[i].geometry.coordinates[2] >= 90) {
                tab += '<tr style = "color:blue;">';
            } else if (feat[i].properties.mag >= 6.0) {
                tab += '<tr style = "color:red;">';
            } else {
                tab += '<tr style = "color:black;">';
            }
    
            date = moment.utc(feat[i].properties.time).format("YYYY-MM-DD HH:mm") + " UTC";
            tab += '<td style="width:26%"> ' + (date) + "</td>";
            tab += '<td style="width:8%"> ' + feat[i].properties.mag + "</td>";
            tab += '<td style="width:10%"> ' + feat[i].geometry.coordinates[2] + "</td>";
            tab += '<td style="width:34%"> ' + feat[i].properties.place + "</td>";
            tab += '<td style="width:11%"> ' + Math.round(feat[i].geometry.coordinates[0]  * 100) / 100 + "</td>";
            tab += '<td style="width:11%"> ' + Math.round(feat[i].geometry.coordinates[1]  * 100) / 100  + "</td>";
            tab += "</tr>";
        }   
    }

    jQuery(tableId).append(tab);
}

/* get latest earth quakes */
function addQuakeDataToMap(data, map) {
    var dataLayer = L.geoJson(data, {
        filter: function(feature, layer) {
            return feature.properties.mag >= 4.5;
        },

        onEachFeature: function(feature, layer) {
            var popupText = "Magnitude: " + feature.properties.mag + " Depth:" + feature.geometry.coordinates[2]
                + "<br>Location: " + feature.properties.place 
                + "<br>Lat: " + feature.geometry.coordinates[1]  + " Lon: " + feature.geometry.coordinates[0]
                + "<br>Date: " + (new Date(feature.properties.time))
                + "<br><a href='" + feature.properties.url + "'>More info</a>";
            layer.bindPopup(popupText); }
        });
    layerControl.addOverlay(dataLayer, "Quakes 72h");
}

/* get blot  echo */
function addBlotDataToMap(data, map) {
    var blotData = {
      min: 0,
      max: 20,
      data: []
      };
    var loc = 0;
    for (i=0; i < data.features.length; i++)
    {
        var duration = moment.duration(moment.utc().diff(data.features[i].properties.time));
        var hours = duration.asHours();
        mag = data.features[i].properties.mag;
        dat =  {};
        dat['lon'] = data.features[i].geometry.coordinates[0];
        dat['lat'] = Number(data.features[i].geometry.coordinates[1]);
        dat['depth'] = Number(data.features[i].geometry.coordinates[2]);
        dat['count'] =  20 - hours/12;  /* scale so older blots less red */
        if (dat.depth  >= 50 && mag >= 4.0) {
            blotData.data[loc] = dat;
            if (dat.lon < 0) {
                var dat2 = JSON.parse(JSON.stringify(dat));
                dat2.lon = dat2.lon+360;         
                loc++;
                blotData.data[loc] = dat2;
                /*
                var dat3 = JSON.parse(JSON.stringify(dat));
                dat3.lon = dat.lon+720;         
                loc++;
                blotData.data[loc] = dat3;
                */
            }
            else {
                var dat2 = JSON.parse(JSON.stringify(dat));
                dat2.lon = dat2.lon-360;         
                loc++;
                blotData.data[loc] = dat2;
                /*
                var dat3 = JSON.parse(JSON.stringify(dat));
                dat2.lon = dat.lon-720;         
                loc++;
                blotData.data[loc] = dat3;
                */
            }
            loc++;
        }    
    }

    var cfg = {
        "radius": 12,
        "maxOpacity": .4, 
        "scaleRadius": true, 
        "useLocalExtrema": false,
        latField: 'lat',
        lngField: 'lon',
        valueField: 'count'
    };
    blotLayer = new HeatmapOverlay(cfg);
    blotLayer.setData(blotData);
    blotLayer.addTo(map);
    /*layerControl.addOverlay(blotLayer, "Blot Echos");*/
    /*
    var dataLayer = L.geoJson(data, {
        filter: function(feature, layer) {
            return feature.properties.mag >= 4.0 && feature.geometry.coordinates[2] >= 90.0;
        },

        onEachFeature: function(feature, layer) {
            var popupText = "Magnitude: " + feature.properties.mag + " Depth:" + feature.geometry.coordinates[2]
                + "<br>Location: " + feature.properties.place
                + "<br>Lat: " + feature.geometry.coordinates[1]  + " Lon: " + feature.geometry.coordinates[0]
                + "<br>Date: " + (new Date(feature.properties.time))
                + "<br><a href='" + feature.properties.url + "'>More info</a>";
            layer.bindPopup(popupText); }
        });
    layerControl.addOverlay(dataLayer, "Blot Markers");
    */
}

/* Build weather layers */
function buildPressureLayer(geometery, record)
{
    console.log("Build pressure layer ");
    console.log(record);
    var pressData = {
      min:  99500,
      max: 102800,
      data: []
      };
    var loc = 0;
    console.log(record.header.la1, record.header.la2);
    for (lat = record.header.la1; lat >= record.header.la2; lat --)
    {
        for (lon = record.header.lo1; lon <= record.header.lo2; lon ++)
        {
            dat =  {};
            if  (lon <= 180)
                dat['lon'] = lon;
            else
                dat['lon'] = lon - 360;
            dat['lat'] = lat;
            dat['pressure'] = Number(record.data[loc]);
            pressData.data[loc] = dat;
            loc++;
        }
    }
		
			var result = ["rgb(36,104, 180)", "rgb(60,157, 194)", "rgb(128,205,193 )", "rgb(151,218,168 )", "rgb(198,231,181)", "rgb(238,247,217)", "rgb(255,238,159)", "rgb(252,217,125)", "rgb(255,182,100)", "rgb(252,150,75)", "rgb(250,112,52)", "rgb(245,64,32)", "rgb(237,45,28)", "rgb(220,24,32)", "rgb(180,0,35)"];

    var cfg = {
         container: document.getElementById('heatmapContainer'),
        "radius": 1,
        "scaleRadius": true, 
        "useLocalExtrema": false,
        maxOpacity: .5,
        minOpacity: .5,
        maxZoom: 8,
        blur: 0,
        gradient: {
            // enter n keys between 0 and 1 here
            // for gradient color customization
            
            '.063': "rgb(36,104, 180)",
            '.126': "rgb(60,157, 194)",
            '.189': "rgb(128,205,193)",
            '.252': "rgb(151,218,168)",
            '.315': "rgb(198,231,181)",
            '.378': "rgb(238,247,217)",
            '.441': "rgb(255,238,159)",
            '.504': "rgb(252,217,125)",
            '.567': "rgb(255,182,100)",
            '.630': "rgb(252,150, 75)",
            '.693': "rgb(250,112, 52)",
            '.756': "rgb(245, 64, 32)",
            '.819': "rgb(237, 45, 28)",
            '.882': "rgb(220, 24, 32)",
            '.945': "rgb(180,  0, 35)",
          },
        latField: 'lat',
        lngField: 'lon',
        valueField: 'pressure'
    };
    var pressureLayer = new HeatmapOverlay(cfg);
    pressureLayer.setData(pressData);
    layerControl.addOverlay(pressureLayer, "MSL Pressure");
}

function buildWeatherLayers(data)
{
    console.log("Build weather layers");
    console.log(data);
	data.forEach(function (record) {
		switch (record.header.parameterCategory + "," + record.header.parameterNumber) {
           case "3,1":
                buildPressureLayer("", record);
                break;
			default:
                console.log("Unknow data item in weather data");
		}
	});
}

// wind-js-leaflet
var windJSLeaflet = new WindJSLeaflet({
	localMode: false,
	map: map,
	/*layerControl: layerControl,*/
	layerControl: null,
	useNearest: false,
    timeISO: null,
    nearestDaysLimit: 7,
    displayValues: true,
    displayOptions: {
        displayPosition: 'bottomleft',
        displayEmptyString: 'No wind data'
    },
    overlayName: 'wind',

    pingUrl: 'alive/',
    latestUrl: 'latest/',
    nearestUrl: 'nearest/',

    errorCallback: handleError
});

/* get last 72 hours of quake data */
var quakeEnd = moment.utc();
var quakeStart = moment(quakeEnd).subtract(72, 'hours')
urlQuake = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=" + quakeStart.format() + "&endtime=" + quakeEnd.format() +"&minmagnitude=3.0"
jQuery.getJSON(urlQuake, function(data) { 
    addBlotDataToMap(data, map);
    addQuakeDataToMap(data, map);
    writeQuakeTable(data, "#quakeList")
 });

/* get current weather data */
// urlWX = "https://localhost:7000/latest_wx";
// jQuery.getJSON(urlWX, function(data) { buildWeatherLayers(data); });

/* add plate layer to map */
/*
plateLayer = L.geoJson(platesGeojson, {
});
layerControl.addOverlay(plateLayer, "Major Faults");
*/
/* Add 100 year quake data */
/*
var quakeData = {
  min: 0,
  max: 10,
  data: [{lat: 24.6408, lon:46.7728, count: 3},{lat: 50.75, lng:-1.55, count: 1}]
};

var loc = 0
for (i=0; i < quake100Geojson.features.length; i++)
{
    dat = quake100Geojson.features[i].properties;
    dat.count = 10;
    quakeData.data[loc] = dat;   
    if (dat.lon < 0) {
        var dat2 = JSON.parse(JSON.stringify(dat));
        dat2.lon = dat2.lon+360;         
        loc++;
        quakeData.data[loc] = dat2;
    }
    else {
        var dat2 = JSON.parse(JSON.stringify(dat));
        dat2.lon = dat2.lon-360;         
        loc++;
        quakeData.data[loc] = dat2;
    }
    loc ++;
}

var cfg = {
  // radius should be small ONLY if scaleRadius is true (or small radius is intended)
  // if scaleRadius is false it will be the constant radius used in pixels
  "radius": 1.5,
  "maxOpacity": .4, 
  // scales the radius based on map zoom
  "scaleRadius": true, 
  // if set to false the heatmap uses the global maximum for colorization
  // if activated: uses the data maximum within the current map boundaries 
  //   (there will always be a red spot with useLocalExtremas true)
  "useLocalExtrema": true,
  // which field name in your data represents the latitude - default "lat"
  latField: 'lat',
  // which field name in your data represents the longitude - default "lng"
  lngField: 'lon',
  // which field name in your data represents the data value - default "value"
  valueField: 'count'
};

// hundred year 5.5 and up quakes 
var quake100Layer = new HeatmapOverlay(cfg);
quake100Layer.setData(quakeData);

layerControl.addOverlay(quake100Layer, "Quakes 100yr");
*/

/* add open weather tiles */
/*
openWeatherClouds = L.tileLayer('http://{s}.tile.openweathermap.org/map/clouds/{z}/{x}/{y}.png', {
    attribution: 'Map data © OpenWeatherMap',
    maxZoom: 18
});

layerControl.addOverlay(openWeatherClouds, "OWM Cloulds");


openWeatherPressure = L.tileLayer('http://{s}.tile.openweathermap.org/map/pressureContour/{z}/{x}/{y}.png', {
    attribution: 'Map data © OpenWeatherMap',
    maxZoom: 18
});

layerControl.addOverlay(openWeatherPressure, "OWM Pressure");
*/
/*
var mapControlsContainer = document.getElementsByClassName("leaflet-control")[0];
var logoContainer = document.getElementById("logoContainer");//
mapControlsContainer.appendChild(logoContainer);
*/



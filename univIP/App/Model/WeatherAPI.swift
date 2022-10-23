//
//  WeatherAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/14.
//

import Foundation

/*
 {
    "publishingOffice": "徳島地方気象台",
    "reportDatetime": "2022-10-13T17:00:00+09:00",
    "timeSeries": [
    {
        "timeDefines":
        [
        "2022-10-13T17:00:00+09:00",
        "2022-10-14T00:00:00+09:00",
        "2022-10-15T00:00:00+09:00"
        ],
        "areas":
        [
            {
            "area": {"name": "北部","code": "360010"},
            "weatherCodes": ["101","101","201"],
            "weathers": ["晴れ　夜のはじめ頃　くもり","晴れ　時々　くもり","くもり　時々　晴れ"],
            "winds": ["北の風","北の風","北西の風　後　北東の風"],
            "waves": ["１メートル","１メートル","１メートル"]},
            {
            "area": {"name": "南部","code": "360020"},
            "weatherCodes": ["101","101","200"],
            "weathers": ["晴れ　夜のはじめ頃　くもり","晴れ　時々　くもり","くもり"],
            "winds": ["北東の風　やや強く","北東の風　後　西の風　海上　では　北東の風　やや強く","西の風　後　東の風"],
            "waves": ["３メートル　うねり　を伴う","３メートル　後　２．５メートル　うねり　を伴う","２．５メートル　後　２メートル　うねり　を伴う"]
            }
        ]
     },
     {
     "timeDefines": ["2022-10-13T18:00:00+09:00","2022-10-14T00:00:00+09:00","2022-10-14T06:00:00+09:00","2022-10-14T12:00:00+09:00","2022-10-14T18:00:00+09:00"],
     "areas": [
     {
        "area": {
            "name": "北部",
            "code": "360010"
        },
     "pops": [
     "0",
     "0",
     "0",
     "0",
     "0"
     ]
     },
     {
     "area": {
     "name": "南部",
     "code": "360020"
     },
     "pops": [
     "0",
     "0",
     "10",
     "10",
     "10"
     ]
     }
     ]
     },
     {
     "timeDefines": [
     "2022-10-14T00:00:00+09:00",
     "2022-10-14T09:00:00+09:00"
     ],
     "areas": [
     {
     "area": {
     "name": "徳島",
     "code": "71106"
     },
     "temps": [
     "17",
     "25"
     ]
     },
     {
     "area": {
     "name": "池田",
     "code": "71066"
     },
     "temps": [
     "13",
     "25"
     ]
     },
     {
     "area": {
     "name": "日和佐",
     "code": "71266"
     },
     "temps": [
     "19",
     "27"
     ]
     }
     ]
     }
     ]
     },
     {
     "publishingOffice": "徳島地方気象台",
     "reportDatetime": "2022-10-13T17:00:00+09:00",
     "timeSeries": [
     {
     "timeDefines": [
     "2022-10-14T00:00:00+09:00",
     "2022-10-15T00:00:00+09:00",
     "2022-10-16T00:00:00+09:00",
     "2022-10-17T00:00:00+09:00",
     "2022-10-18T00:00:00+09:00",
     "2022-10-19T00:00:00+09:00",
     "2022-10-20T00:00:00+09:00"
     ],
     "areas": [
     {
     "area": {
     "name": "徳島県",
     "code": "360000"
     },
     "weatherCodes": [
     "101",
     "201",
     "202",
     "203",
     "202",
     "201",
     "101"
     ],
     "pops": [
     "",
     "20",
     "60",
     "80",
     "50",
     "30",
     "20"
     ],
     "reliabilities": [
     "",
     "",
     "B",
     "A",
     "C",
     "A",
     "A"
     ]
     }
     ]
     },
     {
     "timeDefines": [
     "2022-10-14T00:00:00+09:00",
     "2022-10-15T00:00:00+09:00",
     "2022-10-16T00:00:00+09:00",
     "2022-10-17T00:00:00+09:00",
     "2022-10-18T00:00:00+09:00",
     "2022-10-19T00:00:00+09:00",
     "2022-10-20T00:00:00+09:00"
     ],
     "areas": [
     {
     "area": {
     "name": "徳島",
     "code": "71106"
     },
     "tempsMin": [
     "",
     "17",
     "19",
     "17",
     "15",
     "14",
     "13"
     ],
     "tempsMinUpper": [
     "",
     "20",
     "21",
     "18",
     "17",
     "16",
     "15"
     ],
     "tempsMinLower": [
     "",
     "16",
     "17",
     "15",
     "14",
     "12",
     "11"
     ],
     "tempsMax": [
     "",
     "25",
     "26",
     "23",
     "20",
     "20",
     "21"
     ],
     "tempsMaxUpper": [
     "",
     "28",
     "27",
     "27",
     "22",
     "23",
     "23"
     ],
     "tempsMaxLower": [
     "",
     "24",
     "24",
     "22",
     "18",
     "18",
     "18"
     ]
     }
     ]
     }
     ],
     "tempAverage": {
     "areas": [
     {
     "area": {
     "name": "徳島",
     "code": "71106"
     },
     "min": "15.7",
     "max": "23.0"
     }
     ]
     },
     "precipAverage": {
     "areas": [
     {
     "area": {
     "name": "徳島",
     "code": "71106"
     },
     "min": "6.5",
     "max": "46.3"
     }
     ]
     }
 }
 */

class TopNest: Codable {
    class area: Codable{
        var weatherCodes: [String]
        var weathers: [String]
    }
    class tempAverage: Codable{
        class areas: Codable{
            var min: String
            var max: String
        }
    }
}



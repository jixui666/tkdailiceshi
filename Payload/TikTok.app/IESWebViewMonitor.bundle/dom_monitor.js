;
(function() {
    
var bd_global = typeof window !== 'undefined'? window : typeof bd_global !== 'undefined' ? bd_global : typeof self !== 'undefined' ? self : {};
function guid() {
     return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
         var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
         return v.toString(16);
     });
 }
 var currentNaviID = guid();
 function needReport(params) {
    if (window.location.href === 'about:blank') {
        return false;
    }
    return true;
 }

 // pv
 function jsIESLiveTimingMonitorReportStage(params, service) {
     if (!needReport(params)) {
         return
     }
     params.serviceType = service
     if (window.webkit) {
         window.webkit.messageHandlers.iesLiveTimingMonitorReportStage.postMessage(formatMonitorParams(params));
     } else if (window.iesLiveTimingMonitorReportStage) {
         iesLiveTimingMonitorReportStage(formatMonitorParams(params));
     }
 }
 
function formatMonitorParams(params) {
    if (window.history.length <= 1) {
        params.firstPage = true
    }
    params.url = window.location.href
    params.navigation_id = currentNaviID
    return JSON.parse(JSON.stringify(params))
}
 
 
 function onDomContentLoaded() {
    var msg = {}
    msg.stage = 'DomContentLoaded';
    jsIESLiveTimingMonitorReportStage(msg, 'pv')
 }
 bd_global.onDomContentLoaded = onDomContentLoaded;
 // Use the handy event callback
 window.addEventListener( "DOMContentLoaded", onDomContentLoaded );
 
})()

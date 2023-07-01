/**
 * @name _http
 * @description Generic API Client using XMLHttpRequest
 * @param {string} url The URI/URL to connect to
 * @param {string} method The HTTP method to invoke- GET, POST, etc
 * @param {function} callback Once the HTTP request has completed, responseText is passed into this function for execution
 * @param {object} params Query Parameters in a JavaScript Object (Optional)
 *
 */
function _http(url, method, callback, params) {
    var xhr,
        reqUrl;

    xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function xhrProc() {
        if (xhr.readyState == 4 && xhr.status == 200) {
            callback(xhr.responseText);
        }
    };


    /** If Query Parameters are present, handle them... */
    if (typeof params === 'undefined') {
        reqUrl = url;
    } else {
        switch (method) {
            case 'GET':
                reqUrl = url + procQueryParams(params);
                break;
            case 'POST':
                reqUrl = url;
                break;
            default:
        }
    }


    /** Send the HTTP Request */
    if (reqUrl) {
        xhr.open(method, reqUrl, true);
        xhr.setRequestHeader("Accept", "application/json");

        if (method === 'POST') {
            xhr.send(params);
        } else {
            xhr.send();
        }
    }


    /**
     * @name procQueryParams
     * @description Return function that converts Query Parameters from a JavaScript Object to a proper URL encoded string
     * @param {object} params Query Parameters in a JavaScript Object
     *
     */
    function procQueryParams(params) {
        return "?" + Object
            .keys(params)
            .map(function (key) {
                return key + "=" + encodeURIComponent(params[key])
            })
            .join("&")
    }
}

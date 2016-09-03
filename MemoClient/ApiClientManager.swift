
import Alamofire

class ApiClientManager {
    private var URLString: String!
    
    init(URLString: String){
        self.URLString = URLString
    }
    
    static func initClient(string: String) -> ApiClientManager{
        return ApiClientManager(URLString: string)
    }
//    ToDo: error callback
    func executeGet(callback: (AnyObject) -> Void){
        Alamofire.request(.GET, URLString)
            .responseJSON{ response in
                let data = response.result.value!
                callback(data)
        }
    }
    
    func executePost(value: String, callback: (Int) -> Void){
        let params = ["memo[value]" : value]
        Alamofire.request(.POST, URLString, parameters: params)
            .responseString{ response in
                if response.result.error == nil {
                    callback((response.response?.statusCode)!)
                }
        }
    }
    
    func executePut(value: String, callback: (Int) -> Void){
        let params = ["memo[value]" : value]
        Alamofire.request(.PUT, URLString, parameters: params)
            .responseString{ response in
                if response.result.error == nil {
                    callback((response.response?.statusCode)!)
                }
        }
    }
    
    func executeDelete(callback: (Int) -> Void){
        Alamofire.request(.DELETE, URLString)
            .responseString{ response in
                if response.result.error == nil {
                    callback((response.response?.statusCode)!)
                }
        }
    }

}


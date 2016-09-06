
import UIKit
import SwiftyJSON

class MemoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    private var memos: [Memo] = [Memo]()
    private var deleteIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        executeLoadMemos()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memoCell", forIndexPath: indexPath) as! MemoCell
        
        cell.setMemo(memos[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            deleteIndexPath = indexPath
            showAlert()
        }
    }
    
    func showAlert() {
        let alert: UIAlertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .Alert)
        
        let DeleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Destructive, handler: executeDelete)
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func executeDelete(alertAction: UIAlertAction!) {
        ApiClientManager.initClient(memos[(deleteIndexPath?.row)!].URLString).executeDelete({ data in
            self.memoTableView.beginUpdates()
            self.memos.removeAtIndex(self.deleteIndexPath!.row)
            self.memoTableView.deleteRowsAtIndexPaths([self.deleteIndexPath!], withRowAnimation: .Automatic)
            
            self.deleteIndexPath = nil
            
            self.memoTableView.endUpdates()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func executeLoadMemos(){
        let URLString: String = "http://192.168.10.16:3001/memos.json"
        memos.removeAll()
        ApiClientManager.initClient(URLString).executeGet({ data in
            self.dispatch_async_global{
                let json = JSON(data)
                let jsonArray = json.arrayObject!
                for jsonObject in jsonArray {
                    let id = jsonObject["id"] as? Int
                    let value = jsonObject["value"] as? String
                    let update = jsonObject["updated_at"] as? String
                    let create = jsonObject["created_at"] as? String
                    let URLString = jsonObject["url"] as? String
                    
                    let memo:Memo = Memo()
                    memo.ID = id
                    memo.value = value
                    memo.update = update
                    memo.create = create
                    memo.URLString = URLString
                    
                    self.memos.append(memo)
                }
                
                self.dispatch_async_main{
                    self.memoTableView.reloadData()
                }
            }
        })
    }

    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    @IBAction func reloadItemClicked(){
        executeLoadMemos()
    }

}


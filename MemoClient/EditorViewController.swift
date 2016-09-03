
import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editTextView: UITextView!
    
    private var originBottomConstraintValue: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotification()
    }
    
    private func registerKeyboardNotification() {
        let notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: #selector(EditorViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(EditorViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardValue = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration : NSTimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! NSTimeInterval
        
        if (originBottomConstraintValue == nil) {
            originBottomConstraintValue = bottomConstraint.constant
        }
        
        bottomConstraint.constant = keyboardValue.height + 8
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let duration : NSTimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]! as! NSTimeInterval
        
        bottomConstraint.constant = originBottomConstraintValue!
        originBottomConstraintValue = nil
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func saveItemClicked(){
        let URLString: String = "http://192.168.10.16:3001/memos"
        let memoString: String = editTextView.text
        ApiClientManager.initClient(URLString).executePost(memoString, callback: { statusCode in
            self.navigationController?.popViewControllerAnimated(true)
        })
    }


}
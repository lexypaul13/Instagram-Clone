//
//  FeedViewController.swift
//  Instagram Clone
//
//  Created by Alex Paul on 3/25/21.
//

import UIKit
import Parse
import MessageInputBar
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
   
    let commentBar = MessageInputBar()
    var posts = [PFObject]()
    var selectedPost:PFObject!
    var showComments = false
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self 
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showComments = false; becomeFirstResponder()
        
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showComments
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Parstagram")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if success{
                print("comment saved")
            } else {
                print("Error saving comment")
            }
        }
        
        tableView.reloadData()
        commentBar.inputTextView.text  = nil
        showComments = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"]as? [PFObject]) ?? []
        
        return comments.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let comments = (post["comments"]as? [PFObject]) ?? []
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
            let user = post["author"] as! PFUser
            cell.userName.text = user.username
            cell.captionLabel.text = post["caption"] as? String
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.pictures.af_setImage(withURL: url)
            return cell
        }
        else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentTableViewCell
            let comment = comments[indexPath.row - 1]
            cell.comment.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.name.text = user.username
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comment = (post["comments"] as? [PFObject]) ?? []

        if indexPath.row == comment.count + 1{
            showComments = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }
//        comment["text"] = "This is a random"
//        comment["post"] = post
//        comment["author"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//        post.saveInBackground { (succes, error) in
//            if succes{
//                print("Comment saved")
//            }
//            else{
//                print("Error saved")
//
//            }
//        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
        
    }
    
    
    
}

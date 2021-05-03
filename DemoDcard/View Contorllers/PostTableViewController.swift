//
//  PostTableViewController.swift
//  DemoDcard
//
//  Created by 黃昌齊 on 2021/5/1.
//

import UIKit

class PostTableViewController: UITableViewController {
    
    var posts = [Post]()
    
    @objc func loadData() {
        let urlStr = "https://www.dcard.tw/service/api/v2/posts"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let posts = try decoder.decode([Post].self, from: data)
                        self.posts = posts
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        refreshControl()
    }
    //下拉更新
    func refreshControl() {
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //文字顏色
        refreshControl?.attributedTitle = NSAttributedString(string: "更新中", attributes: attributes) //顯示字串內容
        refreshControl?.tintColor = UIColor.white //元件顏色
        refreshControl?.backgroundColor = UIColor.systemGray4 //下拉背景顏色
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged) //下拉後執行動作
        tableView.addSubview(refreshControl!)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        else { return PostTableViewCell()}
        
        let post = posts[indexPath.row]
        
        //男版或女版頭貼
        if post.gender == "M" {
            cell.genderImageView.image = UIImage(named: "boy")
        } else {
            cell.genderImageView.image = UIImage(named: "girl")
        }
        //看板名稱
        cell.forumNameLabel.text = post.forumName
        //學校名稱
        if let school = post.school {
            cell.schoolLabel.text = school
        } else {
            cell.schoolLabel.text = "匿名"
        }
        cell.titleLabel.text = post.title //標題
        cell.excerptLabel.text = post.excerpt //內文
        cell.likeCountLabel.text = "\(post.likeCount)" //按讚數
        cell.commonCountLabel.text = "\(post.commentCount)" //評論數
        
        //預覽文章照片
        if post.mediaMeta.count != 0 {
            let imageUrl = post.mediaMeta[0].url
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.articleImageView.image = UIImage(data: data)
                        cell.articleImageView.isHidden = false
                    }
                }
            }.resume()
        } else {
            cell.articleImageView.isHidden = true //如果沒有預覽照片則隱藏imageView
        }
        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

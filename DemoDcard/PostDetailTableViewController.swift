//
//  PostDetailTableViewController.swift
//  DemoDcard
//
//  Created by 黃昌齊 on 2021/5/4.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    var post: Post! 
    var postDetail: PostDetail?
    var comments = [Comments]()
    
    @IBOutlet weak var contentView: ContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.contentLabel.text = ""
        loadPostDetailData()
        loadCommentsData()
     
        //男生女生大頭貼, 男/女同學
        if post.gender == "M" {
            contentView.genderImageView.image = UIImage(named: "boy")
            contentView.studentLabel.text = "男同學"
        } else {
            contentView.genderImageView.image = UIImage(named: "girl")
            contentView.studentLabel.text = "女同學"
        }
        //學校
        if let school = post.school {
            contentView.schoolLabel.text = school
        } else {
            contentView.schoolLabel.text = "匿名"
        }
        contentView.titleLabel.text = post.title //標題
        contentView.forumNameLabel.text = post.forumName //看板名稱
        if let likeCount = postDetail?.likeCount,
           let commentCount = postDetail?.commentCount {
            contentView.likeCountLabel.text = "\(likeCount)"
            contentView.commentCountLabel.text = "\(commentCount)"
        } else {
            contentView.likeCountLabel.text = "0"
            contentView.commentCountLabel.text = "0"
        }
    }
    
    
    func loadPostDetailData() {
        let urlStr = "https://www.dcard.tw/service/api/v2/posts/\(post.id)"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
                    }
                })
                if let data = data, let postDetails = try? decoder.decode(PostDetail.self, from: data) {
                    self.postDetail = postDetails
                    print(postDetails)
                    //將內文以 \n 拆開，並存入 array
                    let contentSplit = self.postDetail?.content.split(separator: "\n").map(String.init)
                    let mutableAttributedString = NSMutableAttributedString()
                    contentSplit?.forEach({ row in
                        if row.contains("https") {
                            mutableAttributedString.append(imageSource: row, labelText: self.contentView.contentLabel)
                        } else {
                            mutableAttributedString.append(string: row)
                        }
                    })
                    
                    DispatchQueue.main.async {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/mm/dd hh:mm"
                        let timeText = formatter.string(from: postDetails.createdAt)
                        self.contentView.dateLabel.text = timeText
                        self.contentView.contentLabel.attributedText = mutableAttributedString
                        self.tableView.reloadData()
                    }
                }
            }.resume()
        }
    }
    
    func loadCommentsData() {
        let urlStr = "https://www.dcard.tw/service/api/v2/posts/\(post.id)/comments"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
                    }
                })
                if let data = data, let comment = try? decoder.decode([Comments].self, from: data) {
                    self.comments = comment
                    print(comment)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }.resume()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return contentView
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as? PostDetailTableViewCell
        else { return PostDetailTableViewCell() }
        
        let comment = comments[indexPath.row]
        
        if comment.gender == "M" {
            cell.genderImage.image = UIImage(named: "boy")
        } else {
            cell.genderImage.image = UIImage(named: "girl")
        }
        if let school = comment.school {
            cell.schoolLabel.text = comment.school
        } else {
            cell.schoolLabel.text = "匿名"
        }
        cell.floorLabel.text = "B\(comment.floor)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/mm/dd hh:mm"
        let timeText = formatter.string(from: comment.createdAt)
        cell.dateLabel.text = timeText
        cell.commentLabel.text = ""
        cell.commentLabel.text = comment.content

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

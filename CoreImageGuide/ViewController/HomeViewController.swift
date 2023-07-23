//
//  HomeViewController.swift
//  CoreImageGuide
//
//  Created by shengangneng on 2023/7/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        var table = UITableView(frame: CGRectZero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Image Guide"
        view.addSubview(tableView)
        tableView.frame = CGRectMake(0, 0, Marcon.kScreenWidth, Marcon.kScreenHeight)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let params: [String : Any] = HomeData.titleList[section]
        return (params["item"] as! [[String]]).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { HomeData.titleList.count }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let params: [String : Any] = HomeData.titleList[section]
        return params["header"] as? String
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if header == nil {
            header = UITableViewHeaderFooterView(reuseIdentifier: "header")
            header?.textLabel?.textColor = UIColor.systemBlue
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView .dequeueReusableCell(withIdentifier: "id")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "id")
            cell?.accessoryType = .disclosureIndicator
        }
        guard HomeData.titleList.count - 1 >= indexPath.row else { return cell! }
        let params: [String : Any] = HomeData.titleList[indexPath.section]
        let item = params["item"] as! [[String]]
        let data = item[indexPath.row]
        cell!.textLabel?.text = data[1]
        cell!.detailTextLabel?.text = data[2]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let params: [String : Any] = HomeData.titleList[indexPath.section]
        let item = params["item"] as! [[String]]
        let className = item[indexPath.row][0]
        guard let vc = getVCByClassString(className) else { return }
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

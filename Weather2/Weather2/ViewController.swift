//
//  ViewController.swift
//  Weather2
//
//  Created by Robert D. Brown on 9/6/17.
//  Copyright © 2017 Robert D. Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var tempArray = ["1","2","3","4","5","6","7"]
    var cityName = ""
    var todaysDate = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getJSONData()
        let date = Date()
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day], from: date)
        let year = component.year
        let month = component.month
        let day = component.day
    }
    
    func getJSONData()
    {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=Chicago,us&units=Imperial&cnt=16&appid=8388eeb10004fd4f6dccbbdbef480c30")!
        let session = URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if let JSONObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
            {
                self.tempArray = [String]()
                let cityDictionary = JSONObject.object(forKey: "city") as! NSDictionary
                self.cityName = cityDictionary.object(forKey: "name") as! String
                let arrayList = JSONObject.object(forKey: "list") as! NSArray

                for index in 0..<arrayList.count
                {
                    let outerTemp = arrayList[index] as! NSDictionary
                    let temp = outerTemp.object(forKey: "temp") as! NSDictionary
                    let day = temp.object(forKey: "day") as! Double
                    let tempString = "\(day)"
                    let weatherDictionary = outerTemp.object(forKey: "weather") as! NSArray
                    
                    self.tempArray.append(tempString)
                }
                
                OperationQueue.main.addOperation
                    {
                    self.navigationItem.title = self.cityName
                    self.tableView.reloadData()
                    }
            }
        }
        session.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = tempArray[indexPath.row]
        //cell.imageView?.image = tempArray[indexPath.row].icon
        return cell
    }
}

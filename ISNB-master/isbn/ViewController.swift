//
//  ViewController.swift
//  isbn
//
//  Created by Walter Llano on 30/10/2016.
//  Copyright © 2016 Walter Llano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var cover: UILabel!
    @IBAction func Search(_ sender: UIButton) {
        
        self.name.text = ""
        self.autor.text = ""
        self.cover.text = ""
        
        let url = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let urlComplete = "\(url)\(self.search.text!)"
        let urlFull = URL(string: urlComplete)
        if let datos = try? Data(contentsOf: urlFull!){
            do{
                let json = try JSONSerialization.jsonObject(with: datos, options: JSONSerialization.ReadingOptions.mutableLeaves)
                if (json as AnyObject).count>0{
                    let response = json as! NSDictionary
                    let book = response["ISBN:"+self.search.text!] as! NSDictionary
                    let name = book["title"] as! NSString as String
                    self.name.text = name

                    self.autor.text = book["by_statement"] as! NSString as String
                        
                        if let imagen = book["cover"] as? NSDictionary{
                            DispatchQueue.main.async(execute: {
                                let url = URL(string: imagen["large"] as! String)
                                let data = try? Data(contentsOf: url!)
                                self.imgCover.image = UIImage(data: data!)
                            })
                        }
                        else{

                    self.cover.text = "La portada no esta disponible"}
                }else{
                    let alertController = UIAlertController(title: "OpenLibrary Request", message:
                        "No found any book with this imbn", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
                
                
            }catch _{
            }
        }else{
            let alertController = UIAlertController(title: "OpenLibrary Request", message:
                "Please verify your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func ButtonClear(_ sender: UIButton) {
        self.search.text = ""
        self.name.text = ""
        self.autor.text = ""
        self.cover.text = ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


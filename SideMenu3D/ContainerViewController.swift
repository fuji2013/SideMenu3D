//
//  ContainerViewController.swift
//  SideMenu3D
//
//  Created by FUJISAWAHIROYUKI on 2015/04/27.
//  Copyright (c) 2015年 sample. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    // センター画面とサイドメニュー画面のプロパティ
    let centerViewController: CenterViewController!
    let sideMenuViewController: SideMenuViewController!
    
    // サイドメニューの画面幅
    let menuWidth = 60.0
    
    // サイドメニュー表示・非表示アニメーションの時間
    let animationDuration:CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // センター画面を追加
        addChildViewController(centerViewController)
        view.addSubview(centerViewController.view)
        centerViewController.didMoveToParentViewController(self)
        
        // サイドメニュー画面を追加
        addChildViewController(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMoveToParentViewController(self)
        
        
    }
    
    // カスタムイニシャライザの作成
    init(center:CenterViewController, sideMenu: SideMenuViewController){
        centerViewController = center
        sideMenuViewController = sideMenu
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // init(coder aDecoder: NSCoder)は使わない
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

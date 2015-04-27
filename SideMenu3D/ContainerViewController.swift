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
    let menuWidth:CGFloat = 60.0
    
    // サイドメニュー表示・非表示アニメーションの時間
    let animationDuration:NSTimeInterval = 0.5
    
    // サイドメニュー画面が開いているかどうかのフラグ
    var isOpening = false
    
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
        
        sideMenuViewController.view.layer.anchorPoint.x = 1.0
        sideMenuViewController.view.frame = CGRect(x: -menuWidth, y: 0.0, width: menuWidth, height: view.bounds.height)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        view.addGestureRecognizer(panGesture)
        
        setToPercent(0.0)
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
    
    // ドラッグの処理
    func handleGesture(gesture: UIPanGestureRecognizer){
        
        // ドラッグした距離を取得(前回handleGestureが呼ばれたときからの差分ではない)
        let translation = gesture.translationInView(gesture.view!.superview!)
        
        // isOpeningがtrue → 右ドラッグでサイドメニューを開いている。
        // isOpeningがfalse → 左ドラッグでサイドメニューを閉じようとしている。translation.xがマイナスなので、-1.0をかけて、正にしている。
        var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
        progress = min(max(progress, 0.0), 1.0)
        
        // ドラッグの状態
        switch gesture.state{
        case .Began:
            // 0.0なら閉じてる。1.0以上ならサイドメニューが完全に開いている
            // 0.0ならisOpeningをtrueにする。→ これから画面を開くモードに変更
            // 1.0ならisOpeningをfalseにする。→ これから画面を閉じるモードに変更
            let isOpen = floor(centerViewController.view.frame.origin.x / menuWidth)
            isOpening = isOpen == 1.0 ? false : true
            
            // サイドメニューを開くアニメーションはものすごく処理パワーを使うので画面のキャッシュを利用する
            sideMenuViewController.view.layer.shouldRasterize = true
            sideMenuViewController.view.layer.rasterizationScale = UIScreen.mainScreen().scale
            
        case .Changed:
            // ドラッグの進行状況に応じて画面を動かす
            self.setToPercent(isOpening ? progress : (1.0 - progress))
        case .Ended: fallthrough
        case .Cancelled: fallthrough
        case .Failed :
            // ドラッグの進行状況がmenuWidthの半分を超えていなければ、元にもどす
            // 超えていれば、サイドメニューを完全に開くまたは完全に閉じる
            var goalProgress: CGFloat
            if isOpening{
                goalProgress = progress < 0.5 ? 0.0 : 1.0
            }else{
                goalProgress = progress < 0.5 ? 1.0 : 0.0
            }
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                self.setToPercent(goalProgress)
                }, completion: {
                    _ in
                    // アニメーションが終わったので、サイドメニュー画面のキャッシュを終了する
                    self.sideMenuViewController.view.layer.shouldRasterize = false
            })
        default:
            break
        }
    }
    
    // ドラッグの進行状況に応じて、センター画面とサイドメニュー画面を移動する
    func setToPercent(progress: CGFloat){
        // センター画面を移動する
        centerViewController.view.frame.origin.x = menuWidth * progress
        
        // サイドメニュー画面をアニメーションする
        sideMenuViewController.view.layer.transform = menuTransformForProgress(progress)
        sideMenuViewController.view.alpha = CGFloat(max(0.2, progress))
    }
    
    // ドラッグの進行状況に応じて、サイドメニューの3Dアニメーションを作成する
    func menuTransformForProgress(progress: CGFloat) -> CATransform3D{
        
        // 初期CATransform3Dの取得
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000
        
        let remainingProgress = 1.0 - progress
        let angle = remainingProgress * CGFloat(-M_PI_2)
        
        let rotation = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
        let translation = CATransform3DMakeTranslation(menuWidth * progress, 0.0, 0.0)
        
        return CATransform3DConcat(rotation, translation)
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

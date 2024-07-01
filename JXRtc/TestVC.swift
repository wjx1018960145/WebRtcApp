//
//  TestVC.swift
//  WebRTCApp
//
//  Created by qicaiyuan on 2024/6/14.
//

import UIKit

class TestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let view = CallVideoView.loadFromNib("CallVideoView")
        
        let voice = CallVoiceView.loadFromNib("CallVoiceView")
        
//        view.backgroundColor = .red
        
        self.view.addSubview(view)
        self.view.addSubview(voice)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kTopBarTotalHeight)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 300, height: 400))
        }
        
        voice.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-kSafeAreaBottom - kTabBarHeight)
        }

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SendNewMessiageViewController.swift
//  LALAS3
//
//  Created by Thomas Liu on 16/9/14.
//  Copyright © 2016年 ThomasLiu. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class SendNewMessiageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //MARK: - 变量
    var lmagelist = UIImage()
    
    let DeivecWidth = UIScreen.main.bounds.width
    let DeivecHeight = UIScreen.main.bounds.height
    
    var TableViewCellHeight:CGFloat = 0
    var controllor:UIImagePickerController?
    
    var Voice_Beng : AVAudioPlayer?
    var imageNumbersAlreadyGot = 0
    var imagePicker     : UIImagePickerController!
    
    var dodododdolist = [false,false,false,false]
    //var imagelist = [UIImage]()
    
    //MARK: - 绑定
    @IBOutlet weak var UITextView_Main: UITextView!
    @IBOutlet weak var UIButton_1: UIButton!
    @IBOutlet weak var UIButton_2: UIButton!
    @IBOutlet weak var UIButton_3: UIButton!
    @IBOutlet weak var UIButton_4: UIButton!
    
    @IBOutlet weak var UIButton_5: UIButton!
    
    var buttonClickNumber = 0
    
    
    //选择 图片 或者 拍摄
    @IBAction func UIButton_1_c(_ sender: UIButton) {
        buttonClickNumber = 1
        Voice_Beng?.play()
        TakePhoto()
    }
    
    @IBAction func UIButton_2_c(_ sender: UIButton) {
        buttonClickNumber = 2
        Voice_Beng?.play()
        TakePhoto()
        UIButton_3.isEnabled = true
        UIButton_3.isHidden = false
    }
    @IBAction func UIButton_3_c(_ sender: UIButton) {
        buttonClickNumber = 3
        Voice_Beng?.play()
        TakePhoto()
        UIButton_4.isEnabled = true
        UIButton_4.isHidden = false
    }
    @IBAction func UIButton_4_c(_ sender: UIButton) {
        buttonClickNumber = 4
        Voice_Beng?.play()
        TakePhoto()
    }
    
    @IBAction func UIButton_location(_ sender: AnyObject) {
        
        let piker = UIImagePickerController()
        piker.delegate = self
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: "请选择", message:nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in}
        let takePictureAction: UIAlertAction = UIAlertAction(title: "拍照", style: .default){ action -> Void in
            //self .initWithImagePickView(type: "拍照")
        }
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "相册", style: .default){ action -> Void in
            //self .initWithImagePickView(type: "相册")
        }
        let moviePictureAction: UIAlertAction = UIAlertAction(title: "摄像", style: .default){ action -> Void in
            //self .initWithImagePickView(type: "摄像")
        }
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(takePictureAction)
        actionSheetController.addAction(choosePictureAction)
        actionSheetController.addAction(moviePictureAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func Xiala(_ sender: AnyObject) {
        UITextView_Main.resignFirstResponder()
    }
    
    @IBAction func Send_Click(_ sender: AnyObject) {
        print("send click")
        let imagelist = gotPhotos(photonumber: imageNumbersAlreadyGot)//图片组
        let loaction:String =  (UIButton_5.titleLabel?.text)!//地点
        
        //时间由服务器来决定
        let detail = UITextView_Main.text//文字
        let device = FFFFFunctions().getDeviceVersion()//🐍备
        
        SaveImagesToLibrary()
    }
    
   
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        let path = Bundle.main.path(forResource: file as String, ofType: type as String)
        let url = NSURL.fileURL(withPath: path!)
        var audioPlayer:AVAudioPlayer?
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
        
    }
    
    func click(note:UIControlEvents)
    {
        print("cc")
    }
    
     //MARK: - imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie  as String {
                    let urlvedio = info[UIImagePickerControllerMediaURL] as? NSURL
                    if let url = urlvedio {
                        print("video url = \(url)")
                    }
                }
                else if stringType == kUTTypeImage as String{
                    let metadata = info[UIImagePickerControllerMediaMetadata] as? NSDictionary
                    if let themetadata = metadata {
                        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
                        if let theimage = image {
                            print("\(themetadata)")
                            //得到了 IMAGE
                            switch buttonClickNumber {
                            case 1:
                                UIButton_1.setImage(theimage, for: .normal)
                                dodododdolist[0] = true
                                UIButton_2.isEnabled = true
                                UIButton_2.isHidden = false
                                imageNumbersAlreadyGot = 1
                            case 2:
                                UIButton_2.setImage(theimage, for: .normal)
                                dodododdolist[1] = true
                                UIButton_3.isEnabled = true
                                UIButton_3.isHidden = false
                                imageNumbersAlreadyGot = 2
                            case 3:
                                UIButton_3.setImage(theimage, for: .normal)
                                dodododdolist[2] = true
                                UIButton_4.isEnabled = true
                                UIButton_4.isHidden = false
                                imageNumbersAlreadyGot = 3
                            case 4:
                                UIButton_4.setImage(theimage, for: .normal)
                                dodododdolist[3] = true
                                imageNumbersAlreadyGot = 4
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func TakePhoto()  {
        let a  = PhotoAvilable()
        if a.IsCameraAvalible() && a.CanShootPhoto(){
            controllor = UIImagePickerController()
            if let thecontrollor = controllor {
                thecontrollor.sourceType = .camera
                thecontrollor.mediaTypes = [kUTTypeImage as String]
                thecontrollor.allowsEditing = true
                thecontrollor.delegate = self
                present(thecontrollor, animated: true, completion: nil)
            }
            else{
                print("boooooooom")
            }
        }
    }
    
    //MARK: - ViewFuncs
    //初始化
    override func viewDidLoad() {
        print("load")
        super.viewDidLoad()

        if let Voice_Beng = self.setupAudioPlayerWithFile(file: "Beng", type:"aiff") {
            self.Voice_Beng = Voice_Beng
        }
        a()

        let btn:UIButton = UIButton(frame: CGRect(x: 50, y: 65, width: 50, height: 50))
        btn.setImage(#imageLiteral(resourceName: "Black"), for: UIControlState.normal)
        self.view.addSubview(btn)
        //给按钮添加点击事件
        btn.addTarget(self, action: #selector(click), for: UIControlEvents.touchUpInside)

    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        print("will")
    }
    
    //动画
    override func viewDidAppear(_ animated: Bool) {
        print("did")
        print(imageNumbersAlreadyGot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func a()  {
        UIButton_1.setBackgroundImage(#imageLiteral(resourceName: "Black"), for: .normal)
        UIButton_1.setTitle("", for: .normal)
        UIButton_2.setBackgroundImage(#imageLiteral(resourceName: "Black"), for: .normal)
        UIButton_2.setTitle("", for: .normal)
        UIButton_2.isEnabled = false
        UIButton_2.isHidden = true
        UIButton_3.setBackgroundImage(#imageLiteral(resourceName: "Black"), for: .normal)
        UIButton_3.setTitle("", for: .normal)
        UIButton_3.isEnabled = false
        UIButton_3.isHidden = true
        UIButton_4.setBackgroundImage(#imageLiteral(resourceName: "Black"), for: .normal)
        UIButton_4.setTitle("", for: .normal)
        UIButton_4.isEnabled = false
        UIButton_4.isHidden = true
        
        UITextView_Main.frame = CGRect(x:10,y:5,width:DeivecWidth - 20,height:DeivecHeight / 3)//UITextView_Main占据屏幕的三分之一（上下高度）
        
        let w = (DeivecWidth - 20 - 9) / 4
        
        UIButton_1.frame = CGRect(x:10,y:(DeivecHeight / 3) + 10,width:w,height:w)
        UIButton_2.frame = CGRect(x:10 + w + 3,y:(DeivecHeight / 3) + 10,width:w,height:w)
        UIButton_3.frame = CGRect(x:10 + 2 * w + 6,y:(DeivecHeight / 3) + 10,width:w,height:w)
        UIButton_4.frame = CGRect(x:10 + 3 * w + 9,y:(DeivecHeight / 3) + 10,width:w,height:w)
        
        UIButton_5.frame = CGRect(x:10,y: (DeivecHeight / 3) + 15 + w,width:DeivecWidth - 20,height:45)
        UIButton_5.setTitle("   选择地点", for: .normal)
        UIButton_5.layer.cornerRadius = 3
        UIButton_5.clipsToBounds = true
        UIButton_5.contentHorizontalAlignment = .left
    }
    
    func SaveImagesToLibrary() {
        let a = gotPhotos(photonumber: imageNumbersAlreadyGot)
        print(imageNumbersAlreadyGot)
        print(a.count)
        for i in a {
            UIImageWriteToSavedPhotosAlbum(i, self, nil, nil)
        }
    }
    
    func gotPhotos(photonumber:Int) -> [UIImage] {
        var a = [UIImage]()
        switch photonumber {
        case 4...4://4
            a = [UIButton_4.currentImage!] + a
            fallthrough
        case 3...4://3
            a = [UIButton_3.currentImage!] + a
            fallthrough
        case 2...4://2
            a = [UIButton_2.currentImage!] + a
            fallthrough
        case 1...4://1
            a = [UIButton_1.currentImage!] + a
        default:
            break
        }
        return a
    }
    
    /*
     private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
     let mediaType = info[UIImagePickerControllerMediaType] as! String
     let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.compareCaseInsensitive)
     
     if compareResult == CFComparisonResult.compareEqualTo {
     let moviePath = info[UIImagePickerControllerMediaURL] as? NSURL
     //获取路径
     let moviePathString = moviePath!.relativePath
     if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePathString!){
     UISaveVideoAtPathToSavedPhotosAlbum(moviePathString!, nil, nil, nil)
     }
     print("视频")
     }else {
     print("图片")
     _ = info[UIImagePickerControllerOriginalImage] as? UIImage
     //lmagelist.append(image!)
     //self.tableView.reloadData()
     //得到了 image //怎么传达 tableview 的控件上？、
     //self.imageView!.image =  image;
     }
     imagePicker.dismiss(animated: true, completion: nil)
     }*/
    
    
    /*
     func initWithImagePickView(type:NSString){
     self.imagePicker = UIImagePickerController()
     self.imagePicker.delegate      = self;
     self.imagePicker.allowsEditing = true;
     
     switch type{
     case "拍照":
     self.imagePicker.sourceType = .camera
     case "相册":
     self.imagePicker.sourceType = .photoLibrary
     case "摄像":
     self.imagePicker.sourceType = .camera
     self.imagePicker.videoMaximumDuration = 60 * 3
     self.imagePicker.videoQuality = .type640x480
     self.imagePicker.mediaTypes = [String(kUTTypeMovie)]
     default:
     print("error")
     }
     self.present(self.imagePicker, animated: true, completion: nil)
     }*/
}

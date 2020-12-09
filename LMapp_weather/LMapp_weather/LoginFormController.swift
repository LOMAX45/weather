//
//  LoginFormController.swift
//  LMapp_weather
//
//  Created by Максим Лосев on 03.12.2020.
//

import UIKit

class LoginFormController: UIViewController {
    
    var users:[[String]] = [
    ["admin", "admin", "admin", "admin"],
    ["testuser", "qwerty", "Test", "User"]
    ]
    
    @IBAction func unwindSegue(sender: UIStoryboardSegue) {}
    @IBOutlet weak var nickNameEntInput: UITextField!
    @IBOutlet weak var passwordEntInput: UITextField!
    @IBAction func enterButtonPressed(_ sender: Any) {}
    @IBOutlet weak var scrollingEnt: UIScrollView!
    
    @IBOutlet weak var nickNameRegInput: UITextField!
    @IBOutlet weak var passwordRegInput: UITextField!
    @IBOutlet weak var nameNameRegInput: UITextField!
    @IBOutlet weak var familyRegInput: UITextField!
    @IBAction func regButtonPressed(_ sender: Any) {}
    @IBOutlet weak var scrollingReg: UIScrollView!
    
    private func alerting (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        // Добавляем кнопку на UIAlertController
        alert.addAction(action)
        
        // Показываем UIAlertController
        present(alert, animated: true, completion: nil)
    }
    
    private func checkInputsFilling () -> Bool {
        return (nickNameRegInput.text != "" && passwordRegInput.text != "" && nameNameRegInput.text != "" && familyRegInput.text != "")
    }
    
    private func checkAvailabilityOfNick (nick: UITextField) -> Int {
        var i = 0
        while i < users.count && nick.text != users[i][0] {
            i += 1
        }
        return i
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        switch identifier {
        case "Registration":
            if !checkInputsFilling() {
                alerting(title: "ОШИБКА", message: "Все поля должны быть заполнены")
                return false
            } else if checkAvailabilityOfNick(nick: nickNameRegInput) < users.count {
                alerting(title: "ОШИБКА", message: "Пользователь с таким ником уже существует.")
                return false
            } else {
                users.append([nickNameRegInput.text!, passwordRegInput.text!, nameNameRegInput.text!, familyRegInput.text!])
                print(users)
                return true
            }
        case "LogOn":
            if checkAvailabilityOfNick(nick: nickNameEntInput) < users.count {
                let checkPass = passwordEntInput.text == users[checkAvailabilityOfNick(nick: nickNameEntInput)][1]
                if checkPass == false {
                    alerting(title: "ОШИБКА", message: "Вы ввели неверный пароль")
                    return false
                } else {
                    return true
                }
            } else {
                alerting(title: "ОШИБКА", message: "Пользователя с таким ником не существует")
                return false
            }
        default:
            return true
        }
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступы внизу UIScrollView, равный размеру клавиатуры
        self.scrollingEnt?.contentInset = contentInsets
        scrollingEnt?.scrollIndicatorInsets = contentInsets

        self.scrollingReg?.contentInset = contentInsets
        scrollingReg?.scrollIndicatorInsets = contentInsets
    }

    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsetsEnt = UIEdgeInsets.zero
        scrollingEnt?.contentInset = contentInsetsEnt
        
        let contentInsetsReg = UIEdgeInsets.zero
        scrollingReg?.contentInset = contentInsetsReg
    }
    
    @objc func hideKeyboard() {
            self.scrollingEnt?.endEditing(true)
            self.scrollingReg?.endEditing(true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        // Присваиваем его UIScrollVIew
        scrollingEnt?.addGestureRecognizer(hideKeyboardGesture)
        
        scrollingReg?.addGestureRecognizer(hideKeyboardGesture)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

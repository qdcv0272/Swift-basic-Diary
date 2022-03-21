//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by changhun kim on 2022/03/18.
//

import UIKit

enum DiaryEditorMode {
  case new
  case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
  func didSelectReigster(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentsTextView: UITextView!
  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var confirmButton: UIBarButtonItem!

  private let datePicker = UIDatePicker()
  private var diaryDate: Date? // DatePicker 에서 선택된 값 저장
  
  weak var delegate: WriteDiaryViewDelegate?
  var diaryEditorMode: DiaryEditorMode = .new

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureContentsTextView()
    self.configureDatePicker()
    self.configureInputField()
    self.configureEditMode()
    self.confirmButton.isEnabled = false
  }

  private func configureEditMode() {
    switch self.diaryEditorMode {
      case let .edit(_, diary):
        self.titleTextField.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateTextField.text = self.dateToString(date: diary.date)
        self.diaryDate = diary.date
        self.confirmButton.title = "수정"

    default:
      break
    }
  }

  private func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: date)
  }

  //TextView 테두리
  private func configureContentsTextView() {
    let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    self.contentsTextView.layer.borderColor = borderColor.cgColor
    self.contentsTextView.layer.borderWidth = 0.5
    self.contentsTextView.layer.cornerRadius = 5.0
  }

  //DatePicker 설정
  private func configureDatePicker() {
    self.datePicker.datePickerMode = .date
    self.datePicker.preferredDatePickerStyle = .wheels
    self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged) // 값이 변경되었을때 action 호출
    self.datePicker.locale = Locale(identifier: "ko-KR")
    self.dateTextField.inputView = self.datePicker
  }

  private func configureInputField() {
    self.contentsTextView.delegate = self
    
    // titleTextField 에 입력될때 마다 action 호출
    self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
  }

  // 등록버튼을 눌렀을때 다이어리 객체를 생성 delegate 전달
  @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
    guard let title = self.titleTextField.text else { return }
    guard let contents = self.contentsTextView.text else { return }
    guard let date = self.diaryDate else { return }

    switch self.diaryEditorMode {
    case .new:
      let diary = Diary(
        uuidString: UUID().uuidString,
        title: title,
        contents: contents,
        date: date,
        isStar: false
      )
      self.delegate?.didSelectReigster(diary: diary)

    case let .edit(indxPath, diary):
      let diary = Diary(
        uuidString: diary.uuidString,
        title: title,
        contents: contents,
        date: date,
        isStar: diary.isStar
      )
      NotificationCenter.default.post(
        name: NSNotification.Name("editDiary"),
        object: diary,
        userInfo: nil
      )
    }
    self.navigationController?.popViewController(animated: true)
  }

  @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
    let formmater = DateFormatter()
    formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
    formmater.locale = Locale(identifier: "ko_KR")
    self.diaryDate = datePicker.date
    self.dateTextField.text = formmater.string(from: datePicker.date)
    self.dateTextField.sendActions(for: .editingChanged) // 날짜가 변경될때마다
  }

  @objc private func titleTextFieldDidChange(_ textField: UITextField) {
    self.validateInputField()
  }

  @objc private func dateTextFieldDidChange(_ textField: UITextField) {
    self.validateInputField()
  }

  //빈 화면 눌렀을때 키보드x
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  //등록 버튼 활성화 여부
  private func validateInputField() {
    // 모든 Text 들이 비어있지 않으면 등록버튼 활성화
    self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
  }
}

// TextView 에 Text 가 입력될때마다 호출
extension WriteDiaryViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.validateInputField()
  }
}

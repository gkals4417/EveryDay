# EveryDay.app

## Project Introduction

매일매일 단어를 저장하고, 저장 현황을 캘린더로 확인할 수 있는 단어장앱 입니다.<br/>
>개발 기간 : 2022년 12월 1일 ~ 2023년 1월 04일<br/>
>참여 인원 : Pulsar ([github](https://github.com/gkals4417/gkals4417)) ([blog](https://velog.io/@gkals4417))

## Environment<br/>

<div align=left>
   <a href="https://developer.apple.com/kr/swift/"><img src="https://img.shields.io/badge/Swift5-FFFFFF?style=flat&logo=Swift&logoColor=F05138"/></a>
   <br/>
   <img src="https://img.shields.io/badge/Xcode 14.0.1-FFFFFF?style=flat&logo=Xcode&logoColor=147EFB"/></a>
   <br/>
   <a href="https://developer.apple.com/documentation/uikit"><img src="https://img.shields.io/badge/UIKit-FFFFFF?style=flat"/></a>
   <br/>
   <a href="https://github.com/jonkykong/FSCalendar#readme"><img src="https://img.shields.io/badge/SideMenu-FFFFFF?style=flat"/></a><a href="https://github.com/jonkykong/HGCircularSlider#readme"><img src="https://img.shields.io/badge/HGCircularSlider-FFFFFF?style=flat"/></a>
   <br/>
   <img src="https://img.shields.io/badge/MacbookPro M1 Max-FFFFFF?style=flat"/></a>
</div> 

## Preview

|FSCalendar|Add Word & WebView|RefreshControl|HGCircularSlider & Timer|
|--------------------|--------------|------------|------------------|
|![1](https://user-images.githubusercontent.com/70322435/210695640-1586eebb-41d4-4038-adcd-d90a2e96b502.gif)|![2](https://user-images.githubusercontent.com/70322435/210695647-8a934180-e34a-4b26-a440-a9c4961fcf72.gif)|![3](https://user-images.githubusercontent.com/70322435/210695649-016883b1-90ac-4813-8248-a46e4f375d2e.gif)|![4](https://user-images.githubusercontent.com/70322435/210695656-2da360ff-dab4-4408-b8b2-45374dc2e52b.gif)
|

### [FSCalendar](https://github.com/WenchaoD/FSCalendar)
* collectionView를 통해 일일해 달력을 만드는 것보다, 외부 라이브러리가 더 편리해서 사용했습니다.<br/>
* 라이브러리의 기본 메서드를 통해 커스터마이징 및 '오늘' 글씨 추가, 단어저장 현황 등을 표현했습니다.
```swift
//캘린더 외형 변경
calendarView.backgroundColor = .white
calendarView.appearance.titleFont = UIFont(name: "BMHANNAAir", size: 15)
calendarView.appearance.weekdayFont = UIFont(name: "BMHANNAAir", size: 15)
calendarView.appearance.subtitleFont = UIFont(name: "BMHANNAAir", size: 10)
calendarView.appearance.headerTitleFont = UIFont(name: "BMHANNAAir", size: 20)
        
calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
calendarView.appearance.subtitleTodayColor = .black
calendarView.appearance.titleTodayColor = .black
calendarView.appearance.selectionColor = Constants.customBlueColor
calendarView.appearance.headerTitleColor = .black
calendarView.appearance.titleWeekendColor = .red
calendarView.appearance.todayColor = .white
calendarView.appearance.eventDefaultColor = Constants.customBlueColor
calendarView.appearance.eventSelectionColor = Constants.customBlueColor
calendarView.appearance.borderRadius = 0.5
calendarView.swipeToChooseGesture.isEnabled = true
        
calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .red
calendarView.calendarWeekdayView.weekdayLabels[1].textColor = .black
calendarView.calendarWeekdayView.weekdayLabels[2].textColor = .black
calendarView.calendarWeekdayView.weekdayLabels[3].textColor = .black
calendarView.calendarWeekdayView.weekdayLabels[4].textColor = .black
calendarView.calendarWeekdayView.weekdayLabels[5].textColor = .black
calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .red
```
```swift
extension WordListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

//날짜를 선택했을 때 저장된 단어를 보여주는 메서드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarSelectArray = []
        for list in savedCoreArray {
            let a = list.savedDate?.formatted(date: .numeric, time: .omitted)
            let b = date.formatted(date: .numeric, time: .omitted)
            
            if a == b {
                calendarSelectArray.append(list)
            }
        }
        print("calendarSelectArray after select date : \(calendarSelectArray)")
    }
    
//달력이 보여질 때마다 저장된 단어를 보여주는 메서드
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarSelectArray = []
        
        for list in savedCoreArray {
            let today = Date().formatted(date: .numeric, time: .omitted)
            let a = list.savedDate?.formatted(date: .numeric, time: .omitted)
            
            if today == a {
                calendarSelectArray.append(list)
            }
        }
    }
    
//캘린더에 단어저장 현황을 보여주는 
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var outNumber: Int = 0
        for list in savedCoreArray {
            let a = list.savedDate?.formatted(date: .numeric, time: .omitted)
            let b = date.formatted(date: .numeric, time: .omitted)
            if a == b {
                outNumber = 1
            } else {

            }
        }
        return outNumber
    }
    
//현재 날짜에 맞게 '오늘' 단어를 보여주는 메서드
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let today = Date()
        var temp = ""
        if today.formatted(date: .numeric, time: .omitted) == date.formatted(date: .numeric, time: .omitted){
            temp = "오늘"
        }
        return temp
    }
}
```
### [HGCircularSlider](https://github.com/HamzaGhazouani/HGCircularSlider)
* 기본 progressview보다 조금 더 시각적으로 보기 편하게 하기 위해 원형의 slider가 필요했습니다.
```swift
//slider의 외형 관련 코드입니다.
progress.backgroundColor = .clear
progress.diskColor = .clear
progress.trackColor = Constants.customLightGrayColor
progress.trackFillColor = Constants.customBlueColor
progress.backtrackLineWidth = 2
progress.thumbRadius = 6
progress.thumbLineWidth = 0
progress.endThumbTintColor = Constants.customBlueColor
progress.minimumValue = 0
progress.maximumValue = 300
progress.diskFillColor = Constants.customLightGrayColor
```

### NotificationCenter
* 키보드가 나타나거나 사라지는 것을 체크하고, 각 상황에 따라 화면을 위로 올리거나 내리기 위해 NotificationCenter를 이용했습니다.
* addObserver를 통해 키보드가 보여지거나 사라지는 상황을 체크하게 했고, viewDidDisappear 메서드에서 화면이 꺼지면 removeObserver를 통해 감시를 해제하게 했습니다.
```swift
override func viewDidLoad() {
   appManager.delegate = self
   super.viewDidLoad()
   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
}
```
```swift
override func viewDidDisappear(_ animated: Bool) {
   NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
   NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
}
```

### RefreshControl
* 테이블뷰의 셀들을 아래로 당겼을 때 코어데이터에 저장된 데이터를 다시 불러오게 했습니다.
* 이 때, 새로고침이 작동한다는 것을 유저에게 알려주기 위해 핸드폰 진동이 울리게 했습니다.
```swift
private let refreshController: UIRefreshControl = UIRefreshControl()

override func viewDidLoad() {
   refreshController.addTarget(self, action: #selector(self.refreshFunc), for: .valueChanged)
}

@objc func refreshFunc() {
   savedCoreArray = appManager.getCoreDataArray()
   tableView.reloadData()
   refreshController.endRefreshing()
   AudioServicesPlaySystemSound(1102)
    }
```

---

## Structure

MVC Pattern<br/>
├── EveryDay<br/>
&nbsp;&nbsp;&nbsp;   ├─ EveryDay.xcdatamodeld<br/>
&nbsp;&nbsp;&nbsp;   ├─ AppDelegate.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ SceneDelegate.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ Assets.xcassets<br/>
&nbsp;&nbsp;&nbsp;   ├─ LaunchScreen.storyboard<br/>
&nbsp;&nbsp;&nbsp;   ├─ Info.plist<br/>
&nbsp;&nbsp;&nbsp;   ├─ Constants.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Models**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ CoreData+CoreDataClass.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ CoreData+CoreDataProperties.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ CoreDataManager.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ EveryDayManager.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Views**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ Main.storyboard<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WordListCell.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WordListCell.xib<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ TotalWordListCell.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ TotalWordListCell.xib<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Controllers**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WordListViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WordDetailViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ TotalWordListViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ TotalWordListDetailViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ QuizViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ InformationViewController.swift<br/>
<br/>
<img width="849" alt="Screenshot 2022-10-13 at 2 33 53 PM" src="https://user-images.githubusercontent.com/70322435/210698737-8deaa479-de93-4b36-9ec2-4cea64e1d815.jpg">

## Troubles & Solution

* 이전 앱인 **날씨보여줭**에서 사용한 것들을 기본적으로 다시 사용하는 것이었기 때문에, 커다란 문제는 없었다.
> removeObserver를 언제...?
viewDidLoad()에서 화면이 로딩되면 addObserver를 불러오는 것은 이해를 했지만, removeObserver를 해야 한다는 것과, 언제 해야 할지 고민을 했다.
화면을 벗어났을 때에는 Observer가 작동하면 안되기 때문에 viewDidDisappear()메서드를 이용해서 화면을 나가면 removeObserver를 작동하게 했다.

* 커스텀 폰트는 어떻게...?
> Storyboard에서 바로 폰트를 바꿔도 되었지만, 코드를 통해 폰트를 바꾸고 싶었다.
생각보다 번거로운 과정이 있었는데, 원하는 폰트를 넣고, Info.plist에 **Fonts provided by application**에서 폰트파일을 추가해야 했다.
그리고 UIFont(name: size: )를 통해 폰트를 사용할 수 있게 되었다.

---

UI관련
[아이콘](https://dribbble.com/shots/13480408-Weather-icons-Dark?utm_source=Clipboard_Shot&utm_campaign=xiaoyufeng&utm_content=Weather%20icons%20%20-%20Dark&utm_medium=Social_Share&utm_source=Clipboard_Shot&utm_campaign=xiaoyufeng&utm_content=Weather%20icons%20%20-%20Dark&utm_medium=Social_Share](https://www.flaticon.com/free-icon/annotation_9149280?term=memo&page=1&position=29&origin=search&related_id=9149280))

---

2023.1.4 앱스토어 출시<br/>


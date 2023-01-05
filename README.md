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

### CollectionView
* 메인 화면에는 저장된 지역의 기본 정보를 보여지게 했습니다.<br/>
* CollectionView의 Cell을 전체 화면으로 한 뒤, Scroll Direction을 Horizontal로 해서 좌, 우로 넘길 수 있게 했습니다.<br/>
* 지역을 수동으로 추가하거나, GPS를 이용해서 지역이 추가되면, 그 지역이 CollectionView의 제일 첫번째로 오게 했습니다.
```swift
self.weatherDatasArray.insert(successData, at: 0)
```

### CoreLocation
* 날씨 어플리케이션에서는 현재 위치를 파악하는 것이 필수이기 때문에, CoreLocation 라이브러리를 이용했습니다.<br/>
* 위치를 파악하는 방법으로 latitude와 longitude값을 얻어서 외부 API로 값을 넘기는 방식을 선택했습니다. (수동으로 지역을 추가하는 경우, 지역 이름을 외부 API로 값을 넘겼습니다.)
```swift
extension MainViewController: CLLocationManagerDelegate{
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
      guard let location = locations.last else {return}
      locationManager.stopUpdatingLocation()
      lat = location.coordinate.latitude
      lon = location.coordinate.longitude
   }
}
```
### Detail Information
* SideMenu의 지역 cell을 선택하면 상세 날씨 정보를 확인할 수 있게 했습니다.<br/>
* 상세 정보의 경우, tableView의 indexPath.row를 이용하여 선택한 지역을 상세 정보로 나올 수 있게 했습니다.<br/>
* SideMenu의 tableViewController에 prepare를 이용하여 날씨 정보를 Detail Information의 viewController로 넘기고, 속성감시자를 통해 날씨 정보의 변동이 생기면 화면에 데이터를 업데이트하도록 했습니다.
```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?){
   if segue.identifier == "toDetailVC"{
      let detailVC = segue.destination as! DetailViewController
      let index = sender as! IndexPath
      DispatchQueue.main.async{
         detailVC.datas = self.weatherManager.weatherDatasArray[index.row]
      }
   }
}
```
```swift
var datas: Welcome?{
   didSet{
      configureCell()
   }
}

private func configureCell(){
   guard let datas = datas else {return}
   locationNameLabel.text = "\(datas.name)"
   humidityLabel.text = "습도 | \(String(describing: datas.main.humidity)) %"
   temperatureLabel.text = "기온 | \(String(format: "%.1f", datas.main.temp)) ℃"
   maxTempLabel.text = "최고 기온 | \(String(format: "%.1f", datas.main.tempMax)) ℃"
   minTempLabel.text = "최저 기온 | \(String(format: "%.1f", datas.main.tempMin)) ℃"
   feelslikeLabel.text = "체감 온도 | \(String(format: "%.1f", datas.main.feelsLike)) ℃"
   pressureLabel.text = "기압 | \(String(describing: datas.main.pressure)) hPa"
   windSpeedLabel.text = "풍속 | \(String(describing: datas.wind.speed)) m/s"
}
```
### TableView & MessageUI
* 탭바에 setting을 추가하여 위치 확인 동의 여부, 개발자 정보, API정보, 문의하기를 tableView로 추가했습니다.<br/>
```swift
//위치 확인 동의 여부
extension SettingViewController: CLLocationManagerDelegate{
   func locationAuthCheck(){
      let status: CLAuthorizationStatus
        
      if #available(iOS 14, *){
          status = locationManager.authorizationStatus
      } else {
          status = CLLocationManager.authorizationStatus()
      }
  
      switch status {
      case .denied:
          locationAuthStatus = "위치정보 : 사용 안함"
          settingArray[0] = locationAuthStatus
      case .authorizedAlways, .authorizedWhenInUse, .restricted:
          locationAuthStatus = "위치정보 : 사용중"
          settingArray[0] = locationAuthStatus
      default:
          print("NULL")
    }
  }
}
```
* 문의하기의 경우, 터치를 하면 바로 개발자의 이메일로 메일을 보낼 수 있게 MessageUI 라이브러리를 선택했습니다.
```swift
func tableView(_ tableView: UItableView, didSelectRowAt indexPath: IndexPath){
   if indexPath.row == 1 {
      let email = "gkals4417@icloud.com"
      let subject = "문의하기"
      let mail = MFMailComposeViewController()
      
      if MFMailComposeViewController.canSendMail(){
         mail.mailComposeDelegate = self
         mail.setToRecipients([email])
         mail.setSubject(subject)
         present(mail, animated: true)
      }
   }
}
```

## Structure

MVC Pattern<br/>
├── WeatherApp<br/>
&nbsp;&nbsp;&nbsp;   ├─ SavedLocationData.xcdatamodeld<br/>
&nbsp;&nbsp;&nbsp;   ├─ AppDelegate.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ SceneDelegate.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ Assets.xcassets<br/>
&nbsp;&nbsp;&nbsp;   ├─ LaunchScreen.storyboard<br/>
&nbsp;&nbsp;&nbsp;   ├─ Info.plist<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Helpers**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ Constants.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Models**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SavedLocationData+CoreDataClass.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SavedLocationData+CoreDataProperties.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ CoreDataManager.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WeatherManager.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ WeatherModel.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ WeatherNetworkManager.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Views**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ Main.storyboard<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ LocationListCell.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SettingCell.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ WeatherCollectionViewCell.swift<br/>
&nbsp;&nbsp;&nbsp;   ├─ **Controllers**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ MainViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ LocationListViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      ├─ SettingViewController.swift<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      └─ DetailViewController.swift<br/>
<br/>
<img width="849" alt="Screenshot 2022-10-13 at 2 33 53 PM" src="https://user-images.githubusercontent.com/70322435/195510181-d3d5dc8d-9d31-420f-9121-e0fa15dfc798.png">

## Troubles & Solution

* CoreData에 파일을 저장하거나 삭제할 때마다 Index: Out of Range 오류가 발생하는 문제
> 기존의 작동방식
1. 앱을 실행하면 기본값으로 설정된 위치를 API로 받아서 배열에 저장한다. 그리고 저장된 배열은 바로 CoreData에 저장된다.
2. 사용자가 위치찾기 버튼을 클릭하거나, 지역을 SearchBar에 입력할 때마다 API로 데이터를 받아서 배열에 append 한다. 마찬가지로 받은 데이터 배열을 CoreData에 저장한다.
3. SideMenu에서 특정 지역을 지우거나 클릭하는 경우 **어떤 경우에는 잘 작동하지만, 어떤 경우에는 오류를 내면서 앱이 종료된다.**

> 기존의 작동 방식은 사용자가 매번 지역을 추가할 때마다 배열에 추가하고 CoreData에 저장하는 방법이다보니, 배열의 index를 읽어오는 데 문제가 많이 발생했습니다.<br/>
> 그래서 매번 데이터를 CoreData에 저장하는 것이 아닌, 앱이 완전히 종료되기 전에 날씨 데이터에서 **지역**만 CoreData에 저장하는 방식으로 변경했습니다.<br/>
1. 사용자가 새롭게 지역을 추가하면 **날씨 데이터**를 임시 배열에 저장한다. (이 앱의 경우 weatherDatasArray)
```swift
func getDatasCityNameFromAPI(cityName: String, completion: @escaping () -> Void){
   networkManager.getchWeatherWithCityName(cityName: cityName){result in
      switch result{
      case .success(let successData):
         self.weatherDatas = successData
         self.weatherDatasArray.insert(successData, at: 0)
         print("WeatherDatasArray : \(self.weatherDatasArray)")
         completion()
      case .failure(let error):
         print(error)
         completion()
      }
   }
}
```
2. 사용자가 앱을 종료하기 직전, CoreData에 임시 배열의 여러 값 중, **위치** 데이터만 뽑아서 배열에 저장한다.
```swift
//SceneDelegate.swift
func sceneDidDisconnect(_ scene: UIScene){
   weatherManager.weatherDatasArray.forEach{ result in
      weatherManager.createLocationData(with: result){
         print("WeatherDatasArray Saved")
         print("SavedCoreData : \(self.weatherManager.locationSavedArray)")
      }
   }
}

```
3. 사용자가 앱을 다시 시작하면 viewDidLoad()에서 위치 배열을 뽑아서 다시 API로 위치 기반 데이터를 받아서 화면에 보여준다.
```swift
//이 경우, CoreData에 데이터가 있는 경우와 없는 경우로 나눴다.
func setupBasicData(){
   if weatherManager.locationSavedArray.isEmpty{
      weatherManager.fetchDatasFromAPI(lat: 37.5326, lon: 127.024612){
         print("Hello Swift")
         DispatchQueue.main.async{
            self.collectionView.reloadData()
         }
      }
   } else {
      var locationArray:[String] = []
      var removeDuplicateArray: [String] = []
      
      weatherManager.locationSavedArray.forEach{ result in
         locationArray.append(result.location ?? "")
         print("Location Array : \(locationArray)")
         
         removeDuplicateArray = Array(Set(locationArray))
         print("flatMapped Location Array : \(removeDuplicateArray)")
      }
      
      for location in removeDuplicateArray{
         weatherManager.fetchDatasCityNameFromAPI(cityName: location){
            DispatchQueue.main.async{
               self.collectionView.reloadData()
            }
         }
      }
   }
}
```

* CoreData Entity의 적절하지 못한 Attribute
> 저장하려는 데이터는 **위치** 한개였으나, Attribute는 privacyLocation, savedDate, units도 함께 넣었습니다.. <br/>
> 어플리케이션 개발 기획 단계에서 더 세밀하게 기획한 다음 개발을 시작해야 겠다는 생각이 들었습니다.

* 사용자가 SearchBar에 지역을 입력하면 CollectionView에서 새로운 지역을 보여줘야 하는데, 그렇지 않았던 문제가 있었습니다.<br/>
> SearchBar의 경우 SideMenu의 ViewController에 있었고(LocationListViewController), CollectionView는 다른 ViewController에 있어서(MainViewController), LocationListViewController에서 MainViewController에게 데이터를 전달하기 위한 **커스텀 델리게이트 패턴**을 이용했습니다.
```swift
//MainViewController.swift

extension MainViewController: ScrollDelegate {
   func views(){
      collectionView.scrollsToTop = true
      collectionView.reloadData()
   }
}

//LocationViewController.swift

extension LocationListViewController: UISearchBarDelegate{
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
      guard let city = locationSearchBar.text else {return}
      weatherManager.fetchDatasCityNameFromAPI(cityName: city){
         DispatchQueue.main.async{
            self.locationTableView.reloadData()
            self.dismiss(animated: true)
            self.delegate?.views()
         }
      }
   }
}
```

* UI를 꾸미기 위한 고민
> 사용하려는 API에 있는 기본적인 날씨 아이콘들을 사용하려고 했으나 원하는 디자인과는 맞지 않아, 직접 일러스트 작업을 통해서 아이콘과 배경을 만들었습니다.<br/>
> 이때 참조한 홈페이지는 아래와 같습니다.

[색 조합 참조](https://colorhunt.co/) <br/>
[날씨 아이콘](https://dribbble.com/shots/13480408-Weather-icons-Dark?utm_source=Clipboard_Shot&utm_campaign=xiaoyufeng&utm_content=Weather%20icons%20%20-%20Dark&utm_medium=Social_Share&utm_source=Clipboard_Shot&utm_campaign=xiaoyufeng&utm_content=Weather%20icons%20%20-%20Dark&utm_medium=Social_Share)

## NEXT...

단위 변경 설정, 개인정보처리방침 등 더 다양한 기능들을 추가하고 출시를 목표로 더 다듬을 계획입니다.

---

2022.11.10 앱스토어 출시<br/>
2022.11.11 API 변경 작업 시작 (WeatherKit)

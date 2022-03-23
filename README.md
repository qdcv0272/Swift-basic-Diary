# Swift-basic-Diary
<hr/>

<h3 align="center"> 🎥 시뮬레이터 🎥 </h3>

<p align="center"> 
  <img src="https://user-images.githubusercontent.com/91595135/159505399-c4b75de7-422e-463b-b0df-46170a36c12a.gif">
</p>
<hr/>

<h3 align="center">🔧 Delegate vs Notification 🔧</h3>

<h4 align="center"> 🚀 Delegate 🚀 </h4>

- Delegate 장점
   - 엄격한 Syntax 로인해 프로토콜 에 필요한 메소드들이 명확한 명시
   * 프로토콜 에 정의되어 있는 메소드 들을 구현하지 않으면 컴파일 에러
   + Notification 필요 x

- Delegate 단점
   - 많은 줄의 코드가 필요
   * 많은 객체들엑 이벤트를 알리는것이 어렵다

<h4 align="center"> 🚀 Notification 🚀 </h4>

NotificationCenter 라는 싱글턴 객체르 통해서 이벤트의 발생 여부를 옵저버를 등록하 객체 들에게 Notification 을 post 하는 방식 사용 </br>
NofiticaionName 이라는 Key 값을 통해 보내고 받을 수 있다.

- Notification 장점
   - 많은 줄의 코드 가 필요없다
   * 다수의 객체 들에 동시에 이벤트를 전달
   + Notification 과 관련되 정보를 Any? 타입의 object, ```[Anyhashable: Any?]``` 타입의 userInfo 전달

- Notification 단점
   - key 값으로 Notification 의 이름과 userInfo 를 서로 맞추기 때문에 컴파일 시 구독ㅇ 잘되고있는지 올바르게 userInfo 의 value 를 받아오는 확인이 불가능 ?
   * Noficication 의 post 이후 그에 대한 응답 정보르 받을 수 없다.
<hr/>

<h3 align="center">🔧 error: Index out of range 🔧</h3>

즐겨찾기 수정 삭제 notification 에 indexPath 를 보내줘서 일기장 화면과 즐쳐찾기 화면에 전달되게 되면 </br> 
일기장 화면 과 즐겨찾기 화면에 일기 갯수가 다를경우 error 발생 </br> 

<h3 align="center">🔧 해결 방법 🔧</h3>

error 해결 방법은 일기를 추가할때마다 diary 객체에 일기의 고유한 값을 저장 하고 즐겨찾기 수정 삭제 notification 에 도 고유한 값 을 저장

<h4 align="center"> 🚀 UUID 🚀 </h4>
UUID는 표준에 따라 이름을 부여하며 고유성을 완벽하게 보장할 수는 없지만 실제 사용 상에서 중복되 가능성이 없다 </br>

 


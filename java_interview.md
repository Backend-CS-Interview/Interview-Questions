## ☕️ 자바 면접 질문 정리

<details>
<summary>StringBuilder 와 StringBuffer 의 차이에 대해 설명해주세요</summary>

<br/>

StringBuilder와 StringBuffer는 내부에서 char[] 배열을 이용해 가변 문자열을 처리하는 클래스입니다. 주요 차이점은 동기화 여부입니다. StringBuilder 는 동기화를 지원하지 않는 반면, StringBuffer는 메서드는 synchronized 키워드로 동기화를 지원하기 때문에 멀티스레드 환경에서 안전하게 동작할 수 있습니다. 성능상으로는 StringBuilder 가 동기화가 없으므로 더 빠르게 동작합니다.

<br/>

<details>
<summary>꼬리질문1: 왜 동기화(synchronized)가 걸려 있으면 느릴까요?</summary>

<br/>
동기화가 성능에 영향을 미치는 이유는 synchronized 키워드로 인해 자바의 모니터 락(monitor lock) 메커니즘이 동작하기 때문입니다. 동기화된 메서드나 블록에 접근하려면 스레드가 락을 먼저 획득해야 하며, 이 과정에서 락 획득(lock acquisition)과 락 해제(lock release)에 따른 추가적인 연산이 발생합니다. 특히, 멀티스레드 환경에서 여러 스레드가 동시에 같은 자원에 접근할 경우, 락 경쟁(lock contention) 이 발생하여 스레드가 대기하는 시간이 길어지고 성능이 저하됩니다. 또한, 스레드 간 컨텍스트 스위칭(context switching), 캐시 미스(cache miss) 와 같은 운영체제 수준의 오버헤드가 발생해 성능에 부정적인 영향을 미칠 수 있습니다.

</details>

<br/>

<details>
<summary>꼬리질문2: 싱글 스레드로 접근한다는 가정하에선 StringBuilder 와 StringBuffer 의 성능이 똑같을까요?</summary>

<br/>
싱글 스레드 환경이라도 StringBuffer 는 동기화된 메서드를 사용하기 때문에 동기화 메커니즘에 따른 락 획득과 해제 비용아 발생합니다. 이러한 비용은 불필요한 오버헤드로 작용하여 성능이 저하됩니다. 반면, StringBuilder는 동기화되지 않아 추가적인 락 처리 과정이 없으므로, 싱글스레드 환경에서도 StringBuilder 가 StringBuffer 보다 성능이 더 빠릅니다.

</details>

<br/>

</details>

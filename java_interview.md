## ☕️ 자바 면접 질문 정리

<details>
<summary>Checked Exception과 Unchecked Exception의 차이점을 설명해주세요.</summary>
<br/>

Checked Exception은 Exception의 하위 예외들 중 RuntimeException을 제외한 모든 예외들을 의미합니다. Checked Exception은 컴파일 시 예외처리를 필수로 해주어야 하며, 해주지 않는다면 컴파일 오류가 발생합니다. 이와 반대로 Unchecked Exception은 RuntimeException과 이를 상속받은 자식 예외들을 가리킵니다. 컴파일 시 예외처리를 해주지 않아도 된다는 것이 특징입니다. 

이 둘의 가장 큰 차이점은 예외 발생 시 트랜잭션 롤백 여부 입니다. Unchecked Exception과 Error는 발생 시 트랜젝션이 롤백됩니다. 하지만 Checked Exception의 경우 예외 발생 시 롤백하지 않습니다. 따라서 Checked Exception을 사용하면서 롤백이 발생하기를 원하는 경우 Checked Exception을 Unchecked Exception으로 바꾸어 주어야 합니다.

```java
@Service
@Transactional
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    public Member createUncheckedEx(){
        Member member = new Member("Uncheck");
        memberRepository.save(member);  // 롤백됨
        if(true) {
            throw new RuntimeException();
        }
        return member;
    }

    public Member createCheckedEx() throws IOException {
        Member member = new Member("Check");
        memberRepository.save(member);  // 롤백되지 않아서 DB에 저장됨
        if(true) {
            throw new IOException();
        }
        return member;
    }
    public Member createEx() throws Exception {
        Member member = new Member("Exception");
        memberRepository.save(member);  // 롤백되지 않아서 DB에 저장됨
        if(true) {
            throw new Exception();
        }
        return member;
    }
}
```
<br/>
</details>

<details>
<summary>HashMap과 Hashtable의 차이점을 설명해주세요.</summary>
<br/>
HashMap과 Hashtable의 가장 큰 차이는 Thread-safe입니다. Hashtable의 모든 데이터 변경 메소드는 synchronized로 선언되어 있습니다. 즉 메소드 호출 전 스레드간 동기화 락을 통해 멀티 스레드 환경에서 data의 무결성을 보장해줍니다. 하지만 HashMap의 경우 Thread-safe하지 않기 때문에 멀티 스레드 환경에서 동시에 객체의 데이터를 조작하는 경우 data의 무결성을 보장할 수 없습니다. 하지만 Hashtable은 느리기 때문에, 동기화를 위해서 ConcurrentHashMap을 사용하는 것이 더 좋은 방법 입니다. 이 외의 차이로 HashMap을 key와 value에 null을 허용하지만, Hashtable의 경우 key와 value에 null을 허용하지 않습니다. 

<br/>
</details>

<details>
<summary>ConcurrentHashMap가 왜 Hashtable보다 성능적으로 우수한지 설명해주세요. </summary>
<br/>

Hashtable은 모든 메서드에 synchronized 키워드를 사용하여 전체 객체에 lock을 걸기 때문에, 한 스레드가 메서드를 호출하는 동안 다른 메서드는 모두 대기해야 하고 다른 스레드로 전환하는 컨텍스트 스위칭에서 성능 저하가 발생합니다. 반면, ConcurrentHashMap은 CAS 연산을 사용하여 읽어들인 현재 값이 스레드가 기대한 값과 동일한지 비교하여, 만약 일치한다면 메모리 위치의 값을 새로운 값으로 원자적으로 교체하고, 일치하지 않으면 다른 스레드가 그 사이에 값을 변경했음을 의미하므로 교체를 실패합니다. CAS 연산은 단일 명령어로 처리되기 때문에 해당 연산이 실행되는 동안에는 다른 어떤 연산도 해당 메모리 주소에 접근할 수 없습니다. 또한 CAS 연산을 사용하면 락이 필요 없기 때문에 락을 획득하고 해제하는 비용을 줄일 수 있고, 다른 스레드가 기다릴 필요 없이 계속해서 실행할 수 있습니다. 만약 CAS가 실패하면 해당 스레드는 다시 값을 읽고 새로운 값을 설정하는 과정을 반복합니다. 이 과정은 대기 없이 진행되기 때문에, 다른 스레드가 대기하는 상황을 피할 수 있습니다. 이를 통해 전반적인 처리 속도가 향상됩니다.

<br/>
</details>


<details>
<summary>오류(Error)와 예외(Exception)의 차이점을 설명해주세요.</summary>

<br/>
Error(오류)는 시스템 레벨에서 발생하는 프로그램 코드로 해결할 수 없는 문제를 나타냅니다. 보통은 JVM에서 발생하며, OOM(Out of Memory), StackOverflowError와 같은 비정상적인 상황에서 발생합니다.

Exception(예외)는 프로그램 실행 중 발생할 수 있는 예외적인 조건을 의미하며, 개발자가 코드 내에서 적절히 처리할 수 있습니다.

따라서 Error는 시스템에 의해 발생하는 비가역적인 문제이고, Exception은 코드 실행 중에 발생하는 예측 가능한 문제라 개발자가 코드로 해결할 수 있습니다.

<details style="margin-left: 20px;">
<summary>꼬리질문1: 에러와 예외를 구분하는 이유를 설명해주세요.</summary>

<br/>
시스템의 안정성 면에서 시스템의 개입이 필요한 에러와 달리, 개발자가 대응할 수 있는 예외를 따로 분류하여 처리를 하면 예외로 넘어가는 많은 경우에서 시스템이 안정적으로 동작할 수 있도록 할 수 있습니다. 또한 유지보수적 관점에서는 둘을 구분함으로써 작업을 줄일 수 있다, 즉 비용 절감의 면에서도 구분을 합니다.

<br/>
</details>


<details style="margin-left: 20px;">
<summary>꼬리질문2: 예외의 종류에는 무엇이 있나요?</summary>

<br/>
예외는 두가지 기준으로 나눌 수 있습니다. 발생하는 시기에 따라 구분하면 컴파일 과정에서 발생하는 IOException, FileNotFound 예외와 런타임에 발생하는 예외, 예를 들어 NPE 등이 있습니다.

또한 Checked Exception, Unchecked Exception으로 나뉩니다. Checked는 컴파일 예외클래스이고 Unchecked는 런타임 예외클래스인데요. 이는 코드적 관점에서 구분됩니다. 이 둘의 핵심적인 차이는 반드시 예외 처리를 해야 하는가? 입니다. Checked는 반드시 예외를 처리해야 하고, Unchecked는 명시적인 처리를 안해도 됩니다.

![image.png](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRK9GVB0oHPub5kRARKKXPUNVghP1rnw4Ci5A&s)

위 그림에서 RuntimeException은 Unchecked, Exception은 Checked입니다. Checked Exception이 발생할 것 같다면 try-catch나 throws로 처리를 해야합니다.
<br/>
</details>

<br/>
</details>


<details>
<summary>자바는 WORA(Write Once, Run Anywhere)라고 하는데 그 이유를 알려주세요.</summary>
<br/>

자바는 플렛폼 독립적 입니다. 자바 소스 코드는 컴파일러에 의해 바이트 코드로 변환되고 이 바이트코드는 JVM에 의해 실행되며, 특정 운영체제나 하드웨어에 종속되지 않습니다. 그 이유는 JVM이 각 플렛폼에 맞는 JVM 구현체가 존재하기 때문입니다. Windows, macOS, Linux 등 각각의 운영체제에 맞는 JVM이 존재하며, 동일한 바이트 코드는 어느 운영체제에도 동일하게 작동합니다. `WORA`는 "한 번 작성하면 어디서나 실행된다"는 원칙입니다. 자바가 WORA인 이유는 자바 개발자가 한번 코드를 작성하면, 어떤 플랫폼에서도 실행할 수 있기 때문입니다. 이러한 특성은 자바의 이식성을 높여주고, 다양한 환경에서의 애플리케이션 배포와 유지보수를 용이하게 합니다. 
<br/>
</details>

<details>
<summary>ArrayList와 LinkedList의 차이점을 설명해주세요.</summary>
<br/>

ArrayList는 배열 기반의 리스트 구현체로, 내부적으로 동적 배열을 사용하여 데이터를 저장합니다. 초기 용량이 초과되면 새로운 배열을 생성하고 기존 데이터를 복사하여 저장합니다. ArrayList는 무작위 접근(random access)이 가능하기 때문에, 인덱스로 접근 시 요소 접근 속도가 빠릅니다. 하지만 요소 추가와 삭제 시 배열의 크기를 조정해야하므로, 빈번한 요소 추가와 삭제가 발생하는 경우 배열의 크기를 조정하는 과정에서 많은 시간이 소요되어 성능이 저하될 수 있습니다.

LinkedList는 연결 리스트 기반의 리스트 구현체로, 각 요소가 이전 요소와 다음 요소의 참조를 가지고 있습니다. 배열의 크기를 조정할 필요가 없기 때문에 공간의 제약이 존재하지 않으며 복사하는 과정이 없어서 삽입과 삭제의 처리 속도가 빠릅니다. 하지만, 요소를 get하는 과정에서 순차접근(sequential access)만 가능하기 때문에 인덱스를 활용하여 조회할 경우 처음부터 순차적으로 탐색해야 하므로 접근 속도가 느립니다. LinkedList에서 맨 앞이나 맨 뒤 요소만 추가하고 삭제하면 시간복잡도는 O(1)이 맞지만, 중간에 요소를 추가하거나 삭제하면 중간 위치까지 탐색을 해야하기에 최종적으로 O(n)이 됩니다. 

삭제 또는 삽입이 빈번하면 LinkedList를 사용하는 것을 사용하는 것이 사용하는 것이 좋아보이지만, 사실 성능면에서 이 둘은 큰 차이가 없습니다. 예를 들어 ArrayList는 리사이징 과정에서 배열 복사하는 추가 시간이 들지만, 배열을 새로 만들고 for문을 돌려 기존 요소를 일일이 대입하는 그러한 처리가 아니라, 내부적으로 최적화가 잘 되어있어서 성능이 크게 차이가 나지 않습니다.

<br/>
</details>

<details>
<summary>String 타입에서 ==와 equals()의 차이점을 설명해주세요.</summary>
<br/>

String 변수를 생성할 때는 리터럴을 사용하는 방식과 new 연산자를 사용하는 방식이 있습니다. 리터럴을 사용하게 되면 string constant pool이라는 영역에 값이 존재하게되고, new를 통해 생성하면 heap 영역에 존재하게 됩니다. String을 리터럴로 선언할 경우 내부적으로 String의 intern() 메서드가 호출되게 되고 intern() 메서드는 주어진 문자열이 string constant pool에 존재하는지 확인하고 있으면 그 주소값을 반환하고 없으면 string constant pool에 넣고 새로운 주소값을 반환합니다.
== 연산자는 비교하는 두 대상의 주소값을 비교하는데 반해 String 클래스의 equals() 메서드는 Objects 클래스의 equals() 메서드를 오버라이딩하여 두 비교대상의 주소 값이 아닌 데이터 값을 비교합니다.

```java
String str1 = "Hello"; // 문자열 리터럴을 이용한 방식
String str2 = "Hello";

String str3 = new String("Hello"); // new 연산자를 이용한 방식
String str4 = new String("Hello");

// 리터럴 문자열 비교
System.out.println(str1 == str2); // true

// 객체 문자열 비교
System.out.println(str3 == str4); // false
System.out.println(str3.equals(str4)); // true

// 리터럴과 객체 문자열 비교
System.out.println(str1 == str3); // false
System.out.println(str3.equals(str1)); // true
```
<br/>
</details>

<details>
<summary>equals()를 재정의할 때 hashCode()도 재정의 해야하는 이유를 설명해주세요.</summary>
<br/>

hashCode 메서드는 객체의 주소 값을 이용해서 해싱 기법을 통해 해시 코드를 만든 후 반환합니다. 엄밀히 말하면 해시코드는 주소값은 아니고, 주소값으로 만든 고유한 숫자값입니다. 
equals()를 재정의할 때 hashCode()도 재정의 해야하는 이유는 equals()의 결과가 true인 두 객체의 해시코드는 반드시 같아야 한다는 자바의 규칙 때문입니다. 만약 두 메소드를 동시에 재정의하지 않을 시, hash 컬렉션을 사용할 때 문제가 발생할 수 있습니다. equlas()만 재정의하면 두 객체의 해시코드가 다름에도 불구하고 논리적으로 같은 객체라고 판단합니다. 이때 HashSet을 사용하여 객체를 추가할 때 해시코드가 달라서 다른 객체라고 판단하여 중복된 객체가 추가될 수 있습니다. 따라서 equals()를 재정의할 때 hashCode()도 동시에 재정의 해야 합니다.

### 추가 설명 
위처럼 동작하는 이유는 hash 컬렉션의 객체가 논리적으로 같은지 비교할때 수행하는 과정에서 찾을 수 있습니다. 가장 먼저 데이터가 추가되면, 그 데이터의 hashCode() 리턴 값을 컬렉션에 가지고 있는지 비교합니다. 해시코드가 다르다면 다른 객체라고 판단하고, 만약 해시코드가 같다면 다음으로 equals() 메서드의 리턴 값을 비교하여 true면 논리적으로 같은 객체라고 판단합니다.

<details style="margin-left: 20px;">
<summary>꼬리질문1: hashCode()를 잘못 오버라이딩하면 hash 컬렉션의 성능이 떨어질 수 있는데 그 이유를 설명해주세요. </summary>
<br/>

Objects.hash 메서드는 매개변수로 주어진 값들을 이용해서 고유한 해시 코드를 생성합니다. 즉, 동일한 값을 가지는 객체들의 필드로 해시코드를 생성하면 동일한 해시코드를 얻을 수 있습니다. Objects.hash 메서드는 가변 인자를 받아 처리하기 때문에 내부적으로 배열을 생성하고, for문을 돌면서 각 필드의 해시코드를 계산하여 반환합니다. 이 과정에서 필드의 순서가 반환되는 해시코드에 영향을 끼칩니다. 따라서 배열의 생성과 for문으로 인해 hash 컬렉션의 성능 저하를 야기할 수 있습니다. 

```java
@Override
public int hashCode() {
    return Objects.hash(name); // name 필드의 해시코드를 반환한다.
}
```
</details>

<br/>
</details>

<details>
<summary>JAVA의 컴파일 과정을 설명해주세요.</summary>

<br/>
먼저 개발자가 자바 소스코드(.java)를 작성합니다.

이후에 자바 컴파일러(javac)가 자바 소스파일을 컴파일 합니다. 이 때 나오는 파일은 바이트코드파일(.class)로 컴퓨터가 아직 읽을 수 없는 JVM이 이해할 수 있는 코드입니다.

컴파일된 바이트코드를 JVM의 클래스로더(Class Loader)로 전달합니다.

클래스 로더는 동적로딩을 통해 필요한 클래스들을 로딩 및 링크하여 런타임 데이터 영역, 즉 JVM의 메모리에 올립니다.

실행엔진(Execution Engine) JVM 메모리에 올라온 바이트 코드들을 명령어 단위로 하나씩 가져와서 실행합니다. 이 때 실행 엔진은 두 가지 방식으로 변경합니다.

1. 인터프리터: 바이트 코드 명령어를 하나씩 읽어서 해석하고 실행합니다. 하나하나의 실행은 빠르나, 전체적인 실행 속도가 느리다는 단점을 가집니다.

2. JIT 컴파일러: 인터프리터의 단점을 보완하기 위해 도입된 방식으로 바이트 코드 전체를 컴파일하여 바이너리 코드로 변경하고 이후에는 해당 메서드를 더 이상 인터프리팅하지 않고 바이너리 코드로 직접 실행하는 방식입니다. 바이트 코드 전체가 컴파일된 바이너리 코드를 실행하는 것이기 때문에 전체적인 실행속도는 인터프리팅 방식보다 빠릅니다.

<details style="margin-left: 20px;">
<summary>꼬리질문1: 클래스 로더의 동작방식을 설명해주세요.</summary>
<br/>
로드: 클래스 파일을 가져와서 JVM 메모리에 로드합니다.

검증: 클래스 로드 전 과정 중에서 가장 복잡하고 시간이 많이 걸리는 과정으로 읽어들인 클래스가 자바 언어 명세 및 JVM에 명시된 대로 구성되어 있는지 검사합니다.

준비: 클래스가 필요로 하는 메모리를 할당합니다.. 필요한 메모리란 클래스에서 정의된 필드, 메서드, 인터페이스들을 나타내는 데이터 구조들 등을 말합니다.

분석: 클래스의 상수 풀 내 모든 심볼릭 레퍼런스를 다이렉트 레퍼런스토 변경합니다.

초기화: 클래스 변수들을 적절한 값으로 초기화합니다.(static 필드들을 설정된 값으로 초기화 등)

</details>

<details style="margin-left: 20px;">
<summary>꼬리질문2: 그렇다면 언제 인터프리터를 사용하고 언제 JIT 컴파일러가 사용되나요?</summary>

<br/>
인터프리터는 처음 프로그램이 실행될 때 사용되어 바이트코드를 명령어 단위로 해석하고 실행합니다. 프로그램 실행 중 특정 코드(특히 자주 호출되는 메소드나 루프)가 핫스팟으로 식별되면, 그 코드에 대해 JIT컴파일러가 기계어로 컴파일하여 성능을 최적화합니다.

</details>
<br/>
</details>

<details>
<summary>JVM의 런타임 데이터 영역에 대해 설명해주세요.</summary>

<br/>

런타임 데이터 영역은 자바 애플리케이션이 실행되는 동안 JVM 이 사용하는 메모리공간으로 메서드(Method)영역, 힙(Heap) 영역, 스택(Stack), PC 레지스터(Program Counter Register), 네이티브 메서드 스택 (Native Method Stack) 영역으로 나뉩니다. 메서드영역, 힙 영역은 모든 스레드(Thread)가 공유하는 영역이고, 나머지 스택영역, PC 레지스터, 네이티브 메서드 스택은 각 스레드마다 생성되는 개별 영역입니다.

<details style="margin-left: 20px;">
<summary>꼬리질문1: 런타임 상수 풀(Runtime Constant Pool) 과 주요 역할에 대해 설명해 주세요</summary>

<br>
런타임 상수 풀은 자바 클래스 파일에서 컴파일 시 포함된 상수와 참조 정보를 런타임에 관리하는 메모리 영역입니다. 클래스가 JVM에 로드될 때 메서드 영역에 할당되며 숫자, 문자열 등 리터럴 상수와 메서드, 필드, 클래스 참조 정보를 포함합니다. 주요 역할은 메모리 절약입니다. 동일한 상수 리터럴은 상수 풀에 한 번만 저장되고, 프로그램에서 여러 번 사용될 때 재사용됩니다. 특히 문자열 상수 풀을 통해 문자열 리터럴이 여러 번 선언되어도 메모리 낭비를 방지할 수 있습니다.  또한, 런타임에 새로운 참조나 상수가 추가될 수 있으며, 자바의 new 키워드로 생성된 객체는 상수 풀이 아닌 힙 메모리에 저장되지만, new 키워드를 사용한 객체가 리터럴 값을 포함하고 있을 때, 그 리터럴에 대한 참조는 상수 풀에서 가져옵니다. 예를 들어, new String("hello")라는 코드를 실행할 경우, "hello"라는 리터럴 자체는 상수 풀에 저장되어 있고, 그 리터럴을 바탕으로 힙에 새로운 String 객체가 생성됩니다.
</br>

### 추가 설명

Runtime Constant Pool 의 역할

**1.클래스 파일의 상수(Constant Pool Table)를 로드**

자바 클래스 파일(.class)에는 컴파일된 상수 정보가 Constant Pool Table이라는 형태로 포함됩니다. Constant Pool Table 은 **리터럴 값(문자열, 숫자 등)**과 메서드, 필드, 클래스에 대한 참조 정보를 포함하고 있습니다.

클래스가 JVM에 의해 로드될 때 이 Constant Pool Table이 Runtime Constant Pool로 옮겨지며, 런타임에 사용됩니다.

**2.리터럴 값과 참조 정보 저장**

상수 리터럴

- 정수, 부동 소수점 숫자, 문자열 등 상수 리터럴

메서드와 필드 참조

- 메서드 호출 시 해당 메서드의 참조를 상수 풀에서 찾습니다. 마찬가지로 필드에 접근할 때도 필드 참조 정보를 상수 풀에서 관리합니다.

클래스와 인터페이스 참조

- 클래스가 처음 로드될 때, 클래스 참조 정보 역시 Runtime Constant Pool에 저장됩니다.

**3.런타임시 동적 상수 할당**

new 키워드로 객체를 생성하거나, 메서드나 필드에 접근할 때, 해당 참조 정보를 동적으로 추가할 수 있습니다. 예를 들어, 문자열 상수 String은 리터럴로 선언될 때 상수 풀에 저장되며, 이미 동일한 리터럴이 존재할 경우 새로운 객체를 생성하지 않고 기존에 있는 상수를 참조합니다.

이를 통해 메모리 사용을 최적화하고, 중복되는 리터럴이 여러 번 생성되지 않도록 합니다.

**4.메모리 절약**

Runtime Constant Pool은 상수와 참조 정보를 공유하여 중복된 상수를 여러 번 생성하지 않도록 합니다. 이는 메모리 절약에 크게 기여하며, 자주 사용되는 상수들에 대해 최적화된 메모리 사용을 보장합니다.

**5.가비지 컬렉션 대상**

Runtime Constant Pool에 저장된 객체나 참조는 가비지 컬렉션의 대상이 될 수 있습니다. 예를 들어, 더 이상 사용되지 않는 참조나 상수는 GC에 의해 메모리에서 해제될 수 있습니다.

</details>

### 추가 설명

<img src="https://github.com/user-attachments/assets/09a9aa2b-f805-4bb1-b02c-dbc1cced12d8">

![image](https://github.com/user-attachments/assets/af5bc8fc-2248-4a49-8498-2fbb62da094f)

<br/>

</details>

<details>
<summary>JVM의 Garbage Collection과 Garbage Collector의 차이를 설명해주세요.</summary>

<br/>

가비지 콜렉션은 JVM에서 Heap 영역에 동적으로 할당했던 메모리 중, 더 이상 사용하지 않는 객체들, 메모리를 자동으로 찾아 해제하는 프로세스입니다. 이를 통해 개발자가 명시적으로 메모리를 해제하지 않아도, 메모리를 안전하게 관리할 수 있습니다. 가비지 콜렉터는 이러한 작업, 즉 가비지 컬렉션을 수행하는 시스템의 구성 요소입니다.

<br/>

<details style="margin-left: 20px;">
<summary>꼬리질문1: 그렇다면 개발자는 가비지콜렉터만 믿고 메모리를 신경쓰지 않아도 되는 것인가요?</summary>

<br/>

그것은 아닙니다. 가비지 컬렉션에도 단점이 존재하는데요. 자동으로 할당 해제를 해준다고 해도, 메모리가 정확히 언제 해제되는지 알 수가 없고, 이를 제어할 수 없습니다. 또한 가비지 컬렉션을 하는 동안은 다른 동작을 멈춰 오버헤드가 발생하는 문제점이 존재합니다.(이를 Stop-The-World, STW라고 합니다. 과거 익스플로러가 악명이 높았던 이유가 잦은 GC 때문이라고 해요.)

</details>

<details style="margin-left: 20px;">
<summary>꼬리질문2: 그렇다면 heap의 구조에 대해서 설명해주세요.</summary>

<br/>

Heap에는 Young영역과 Old영역이 있는데요. Young은 Eden과 Survivor0,1영역으로 나뉩니다. 대부분의 새롭게 생성된 객체는 Young, 특히 Eden에 위치합니다. 여기서 GC가 한번 발생한 후에 살아있는 객체는 Survivor0, Survivor영역이 가득 차게 되면 그 중에서 살아남은 객체를 다른 Survivor로 옮기고 기존 영역은 비웁니다. 이 과정을 반복하면서 살아남아 age가 임계값에 도달한 객체는 Old영역으로 이동하게 됩니다.

</details>

<details style="margin-left: 20px;">
<summary>꼬리질문3: 가비지 컬렉션의 과정을 설명해주세요.(꼬리질문 2번과 엮어서 생각해주세요)</summary>

<br/>

먼저 GC를 실행하기 위해 JVM이 애플리케이션의 실행을 멈춥니다. 이는 Stop-The-World, 즉 STW라는 작업을 하여 실행 중인 스레드를 제외한 모든 스레드의 작업이 중단됩니다. 이후 어떤 Object를 Garbage로 판단할지 설명을 하겠습니다. GC는 특정 객체가 garbage인지 아닌지 판단하기 위해 Reachability라는 개념을 적용하는데요. 객체에 유효한 레퍼런스가 있다면 Reachable, 없다면 Unreachable로 구분하고 unreachable은 수거합니다. 이 때 Mark and Sweep 방식을 이용합니다. root space로부터 그래프 순회를 통해 각각 어떤 객체를 참조하고 있는지 mark, Unreachable 객체들을 heap에서 제거하는 sweep, 이후 분산된 객체들을 heap의 시작 주소로 모아 압축합니다.(이건 종류에 따라 안할 수도 있다고 합니다)

### 추가 설명

Minor GC

Young 영역은 짧게 살아남는 메모리들이 존재하는 공간입니다. 모든 객체는 처음에는 Young에 생성되는데, 이 공간은 Old에 비해 상대적으로 작기 때문에 메모리를 제거하는데 적은 시간이 걸립니다. 따라서 이 공간에서 메모리 상의 객체를 찾아 제거하는데 적은 시간이 걸립니다.

- 과정
  처음 생성된 객체는 Eden에 위치
  Eden영역이 꽉 차게 되면 Minor GC 실행
  Mark 동작을 통해 reachable 객체 탐색
  살아남은 객체는 Survivor 영역으로 이동
  Eden영역에서 unreachable 상태의 객체의 메모리 해제(sweep)
  살아남은 객체들 age 값 1 증가
  또 다시 Eden영역이 새로운 객체들로 가득 차면 minor GC 발생하고 mark한다.
  mark가 된 객체들은 비어있는 Survivor1으로 이동하고 sweep
  다시 살아남은 모든 객체들은 age가 1씩 증가, 이 과정 반복

Major GC(Full GC)

Old 는 길게 살아남는 메모리들이 존재하는 공간입니다. 이들은 Young에서 시작해서 age가 임계값을 달성하여 Old로 이동한(promotion된) 객체들입니다. Major GC는 객체들이 계속 쌓이다가 Old에서 메모리가 부족해지면 발생합니다. Old는 Young보다 상대적으로 큰 공간을 가지고 있어 객체 제거에 많은 시간이 걸립니다. 따라서 STW문제가 발생하게 됩니다.

| GC 종류   | Minor GC               | Major GC              |
| --------- | ---------------------- | --------------------- |
| 대상      | Young Generation       | Old Generation        |
| 실행 시점 | Eden 영역이 꽉 찬 경우 | Old 영역이 꽉 찬 경우 |
| 실행 속도 | 빠름                   | 느림                  |

</details>

<br/>

</details>

<details>
<summary>리플렉션에 대해 설명해주세요.</summary>

<br/>

구체적인 클래스 타입을 알지 못해도 그 클래스의 정보(메소드, 타입, 변수, ...) 에 접근할 수 있게 해주는 기법입니다. 리플렉션은 객체를 통해 클래스의 정보를 분석하여 런타임에 클래스의 동작으로 검사하거나 조작할 수 있습니다. 리플렉션은 런타임에 동작하기 때문에, 컴파일 시점에서 오류를 잡을 수 없다는 단점이 존재하므로 사용에 유의해야합니다.

<details style="margin-left: 20px; display: block">
 <summary>꼬리질문1: 리플렉션이 클래스 정보를 어떻게 가져오는지 설명해주세요.</summary>

<br/>

`Class` 클래스는 자바의 리플렉션 API의 일부로, 클래스와 인터페이스의 메타데이터에 접근할 수 있게 해줍니다. Class 객체는 특정 클래스에 대한 정보를 캡슐화하며, 해당 클래스의 이름, 슈퍼클래스, 구현한 인터페이스, 메서드, 생성자 등의 정보를 제공합니다.<br/>
JVM의 `클래스 로더`는 실행 시에 필요한 클래스를 동적으로 메모리에 로드하는 역할을 합니다. 먼저 기존에 생성된 클래스 객체가 메모리에 존재하는지 확인하고, 있으면 객체의 참조를 반환하고, 없으면 classpath에 지정된 경로를 따라서 클래스 파일을 찾아 해당 클래스 파일을 읽어서 Class 객체로 변환합니다. 만일 못 찾으면 `ClassNotFoundException` 예외를 띄우게 됩니다.<br/>
클래스 로더에 의해서 `.class` 파일이 메모리에 로드될 때, 로드된 `.class` 파일의 클래스 정보들을 가져와 Class 객체가 생성되고, 이 객체가 힙 영역에 자동으로 객체화 됩니다. 이로 인해 new 인스턴스화 없이 바로 가져와 사용할 수 있습니다. 이처럼 Class 객체를 활용하여 원하는 클래스의 정보를 가져올 수 있습니다.

```java
Class stringClass = String.class;
System.out.println(stringClass.getName()); // java.lang.String
```

</details>

<br/>
</details>

<details>
<summary>StringBuilder 와 StringBuffer 의 차이에 대해 설명해주세요.</summary>

<br/>

StringBuilder와 StringBuffer는 내부에서 char[] 배열을 이용해 가변 문자열을 처리하는 클래스입니다. 주요 차이점은 동기화 여부입니다. StringBuilder 는 동기화를 지원하지 않는 반면, StringBuffer는 메서드는 synchronized 키워드로 동기화를 지원하기 때문에 멀티스레드 환경에서 안전하게 동작할 수 있습니다. 성능상으로는 StringBuilder 가 동기화가 없으므로 더 빠르게 동작합니다.

<br/>

<details style="margin-left: 20px;">
<summary>꼬리질문1: 왜 동기화(synchronized)가 걸려 있으면 느릴까요?</summary>

<br/>
동기화가 성능에 영향을 미치는 이유는 synchronized 키워드로 인해 자바의 모니터 락(monitor lock) 메커니즘이 동작하기 때문입니다. 동기화된 메서드나 블록에 접근하려면 스레드가 락을 먼저 획득해야 하며, 이 과정에서 락 획득(lock acquisition)과 락 해제(lock release)에 따른 추가적인 연산이 발생합니다. 특히, 멀티스레드 환경에서 여러 스레드가 동시에 같은 자원에 접근할 경우, 락 경쟁(lock contention) 이 발생하여 스레드가 대기하는 시간이 길어지고 성능이 저하됩니다. 또한, 스레드 간 컨텍스트 스위칭(context switching), 캐시 미스(cache miss) 와 같은 운영체제 수준의 오버헤드가 발생해 성능에 부정적인 영향을 미칠 수 있습니다.

</details>
 
<details style="margin-left: 20px;">
<summary>꼬리질문2: 싱글 스레드로 접근한다는 가정하에선 StringBuilder 와 StringBuffer 의 성능이 똑같을까요?</summary>

<br/>
싱글 스레드 환경이라도 StringBuffer 는 동기화된 메서드를 사용하기 때문에 동기화 메커니즘에 따른 락 획득과 해제 비용아 발생합니다. 이러한 비용은 불필요한 오버헤드로 작용하여 성능이 저하됩니다. 반면, StringBuilder는 동기화되지 않아 추가적인 락 처리 과정이 없으므로, 싱글스레드 환경에서도 StringBuilder 가 StringBuffer 보다 성능이 더 빠릅니다.

<br/>

</details>

<br/>

</details>

</details>

<details>
<summary>자바의 Wrapper 클래스는 무엇이며, 왜 사용하나요?</summary>

<br/>

Wrapper 클래스는 기본 데이터타입을 객체로 다루기 위해 자바에서 제공하는 클래스입니다. 기본 타입은 객체가 아니기 때문에 객체가 필요한 경우 Wrapper 타입을 사용합니다. 예를 들어,컬렉션과 같은 객체만 취급하는 구조에서 Wrapper 클래스를 사용해 기본 타입을 객체로 래핑해서 사용할 수 있습니다.

<br/>

</details>

<details>
<summary>자바에서 오토박싱과 오토언박싱에 대해 설명해주세요.</summary>

<br/>

오토박싱(Autoboxing) 은 자바에서 기본 데이터 타입을 자동으로 해당하는 Wrapper 클래스로 변환하는 과정입니다. 오토언박싱(Unboxing) 은 반대로 Wrapper 객체를 기본 데이터타입으로 자동 변환하는 과정입니다. JDK1.5(자바5) 부터 자동 변환이 지원되어 개발자가 명시적으로 변환할 필요 없이 편리하게 사용할 수 있습니다. 예를 들어, 기본타입과 래퍼타입간 연산이 필요할 때 컴파일러가 자동으로 래퍼타입을 기본타입으로 오토언박싱해 연산을 수행합니다.

<br/>

### 추가 설명

int 와 Integer 를 예로 들자면

Boxing 할때는 Integer.valueOf() 메서드를 사용합니다.

```java
Integer num = Integer.valueOf(10);
```

Unboxing 할때는 Integer.intValue() 메서드를 사용합니다.

```java
int num = Integer.intValue(new Integer(10));
```

이 과정을 컴파일러가 아래처럼 대신 해주는것이 오토박싱과 오토 언박싱 입니다.

```java
int primitiveInt = 10;
Integer wrapperInt = primitiveInt; // 자동으로 Integer로 변환 (오토박싱)

Integer wrapperInt = Integer.valueOf(20);
int primitiveInt = wrapperInt; // 자동으로 int로 변환 (오토언박싱)
```

</details>

<details>
<summary>기본타입과 래퍼타입의 차이점과 어떤 경우에 기본 타입을 사용해야 할 지 설명해 주세요.</summary>

<br/>

기본 타입은 메모리의 스택(stack) 영역에 직접 저장되며, 객체가 아닌 값 자체가 저장됩니다. 반면 래퍼 타입은 메모리의 힙(heap) 영역에 객체로 저장되며, 객체가 참조 변수에 의해 참조됩니다. 기본 타입의 초기화 값은 0 또는 false 와 같은 값으로 null 을 가질 수 없지만 래퍼 타입은 객체이기 때문에 명시적으로 초기화 하지 않는 경우 null 을 가집니다. 또한 래퍼 타입은 불변(immutable) 이므로 객체를 생성한 후에는 그 값을 변경할 수 없습니다. 수정이나 값을 변경할 때는 객체의 값을 변경하는게 아닌, 새로운 값의 객체를 생성해서 반환받습니다. 반면, 기본 타입은 값이 변경될 수 있습니다. 메모리 효율성의 경우 래퍼 타입은 객체를 생성하기 때문에 추가적인 메모리 오버헤드가 발생합니다. 따라서 기본 타입은 성능이 중요한 경우나 단순히 연산을 수행할 때 주로 사용됩니다. 래퍼 타입은 객체를 요구하는 컬렉션 프레임워크나 제네릭에서 주로 사용됩니다.

<br/>

### 추가 설명

자바의 제네릭은 컴파일 시 타입 안전성을 제공하고, 컴파일러는 제네릭을 사용하여 타입 변환을 제거하기 위해 타입 소거(Type Erasure) 를 사용합니다. 이 과정에서 제네릭 클래스의 타입 매개변수는 객체 타입으로 변환되는데, 기본 타입은 객체가 아니기 때문에 제네릭에 사용할 수 없습니다.

</details>

<details>
<summary>추상 클래스와 인터페이스의 차이를 설명해주세요.</summary>

<br/>

추상 클래스나 인터페이스는 추상 메소드를 이용한 구현 원칙을 강제한다는 점은 동일하지만, 추상 클래스는 클래스로서 `클래스와 의미있는 연관관계를 구축`할 때 사용하고, 인터페이스는 `클래스와 별도로 구현 객체가 같은 동작`을 한다는 것을 보장하기 위해 사용합니다. </br>
예시로 동물이라는 추상 클래스를 상속한 앵무새, 고래, 사자라는 클래스가 존재합니다. 동작을 하는 메소드 추가를 위해 수영 동작을 하는 `swimming()` 메소드를 자식 클래스에 추가하려고 합니다. 추후 확장을 위해 추상화 원칙을 따르기 위해 추상 클래스에 추상 메서드인 `swimming()` 메소드를 추가하면 수영을 못하는 앵무새와 사자 클래스도 반드시 해당 메소드를 구현해야한다는 강제성이 생깁니다. 이때 상속에 얽매이지 않는 인터페이스에 추상 메서드를 선언하고 이를 구현하게 하면 `자유로운 타입 묶음을 통해 추상화를 이루게`할 수 있습니다.

<br/>

<img src="https://github.com/user-attachments/assets/beca0fea-3815-4c33-bcdb-5587538cc7e3" />

<br/>

</details>

<details>
<summary>자바에서 오버로딩 조건에 대해 설명해 주세요.</summary>

<br/>

자바 컴파일러는 메서드 시그니처를 바탕으로 호출할 메서드를 결정합니다. 따라서 메서드이름이 같더라도, 매개변수 타입, 개수, 순서가 달라지면 메서드 시그니처가 달라지므로 컴파일러는 이를 서로 다른 메서드로 인식해 오버로딩이 가능해집니다. 반면 반환 타입이나 접근 제어자, 예외는 오버로딩의 기준이 되지 않습니다.

<br/>

### 추가 설명

매개변수의 순서만 달라도 오버로딩이 가능한 것을 유의하자.

```java
public void print(int x, double y) {
    System.out.println("int first, then double: " + x + ", " + y);
}

public void print(double y, int x) {
    System.out.println("double first, then int: " + y + ", " + x);
}

public static void main(String[] args) {
    OverloadingExample ex = new OverloadingExample();
    ex.print(10, 3.14);    // Calls print(int, double)
    ex.print(3.14, 10);    // Calls print(double, int)
}
```

반환타입은 메서드 시그니처의 일부가 아니기 때문에 메서드를 구분하는 기준이 되지 않는다.

```java
public int calculate() { return 0; }
public void calculate() { } // 컴파일 에러 발생: 반환 타입만 다르면 오버로딩 불가능
```

메서드가 던지는 예외의 종류 또한 메서드 시그니처에 포함되지 않기 때문에 같은 이름과 같은 매개변수 목록을 가진 메서드가 다른 예외를 던진다고 하더라도, 컴파일러는 이를 같은 메서드로 인식한다.

```java
public void process() throws IOException { }
public void process() throws SQLException { } // 컴파일 에러 발생: 예외만 다르면 오버로딩 불가능
```

public, private, protected 같은 접근 제어자도 메서드 시그니처에 포함되지 않기 때문에 메서드가 동일한 시그니처를 가지면서 접근 제어자만 다를 경우, 컴파일 에러가 발생한다.

```java
public void display() { }
private void display() { } // 컴파일 에러 발생: 접근 제어자만 다르면 오버로딩 불가능
```

</details>

<details>
<summary>자바의 메서드 시그니처에 대해 설명해주세요.</summary>

<br/>
자바에서 메서드 시그니처는 메서드를 고유하게 식별하는 요소로, 메서드 이름과 매개변수 목록(타입, 개수, 순서)으로 구성됩니다. 메서드 시그니처는 메서드를 호출할 때 컴파일러가 어떤 메서드를 호출해야 할지 결정하는 기준이 됩니다.

<br/>

<details style="margin-left: 20px; display: block">
<summary>꼬리질문1: 반환 타입이나 예외가 메서드 시그니처에 포함되지 않는 이유를 설명해 주세요.</summary>

<br>
메서드 시그니처는 컴파일러가 호출할 메서드를 식별하는 기준입니다. 반환 타입의 경우 메서드 호출 후에 값을 받을 때만 사용되므로, 메서드를 호출할 때 메서드 이름과 매개변수 목록은 동일한데 반환 타입만 다르다면 컴파일러는 어떤 메서드를 호출해야 할지 결정할 수 없습니다. 예외(throws)는 메서드 호출 시 발생할 수 있는 오류를 정의하는 부분이지만, 메서드의 실행과정에서 발생할 수 있는 사항이기 때문에 메서드의 식별에는 적절한 기준이 될 수 없습니다.

<br>

</details>

### 추가 설명

1.메서드 이름  
2.매개변수 목록 (타입, 개수, 순서)

반환 타입, 예외 목록, 접근 제어자는 메서드 시그니처에 포함되지 않으므로, 컴파일러는 이를 기준으로 메서드를 구분하지 않는다.

오버라이딩 시에는 상위 클래스와 정확히 동일한 시그니처를 가져야 한다.

</details>

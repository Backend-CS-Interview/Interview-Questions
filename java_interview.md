## ☕️ 자바 면접 질문 정리
<details>
<summary>오류(Error)와 예외(Exception)의 차이점을 설명해주세요.</summary>

<br/>
Error(오류)는 시스템 레벨에서 발생하는 프로그램 코드로 해결할 수 없는 문제를 나타냅니다. 보통은 JVM에서 발생하며, OOM(Out of Memory), StackOverflowError와 같은 비정상적인 상황에서 발생합니다.

Exception(예외)는 프로그램 실행 중 발생할 수 있는 예외적인 조건을 의미하며, 개발자가 코드 내에서 적절히 처리할 수 있습니다.

따라서 Error는 시스템에 의해 발생하는 비가역적인 문제이고, Exception은 코드 실행 중에 발생하는 예측 가능한 문제라 개발자가 코드로 해결할 수 있습니다.

<details>
<summary>꼬리질문1: 에러와 예외를 구분하는 이유를 설명해주세요.</summary>

<br/>
시스템의 안정성 면에서 시스템의 개입이 필요한 에러와 달리, 개발자가 대응할 수 있는 예외를 따로 분류하여 처리를 하면 예외로 넘어가는 많은 경우에서 시스템이 안정적으로 동작할 수 있도록 할 수 있습니다. 또한 유지보수적 관점에서는 둘을 구분함으로써 작업을 줄일 수 있다, 즉 비용 절감의 면에서도 구분을 합니다.

<br/>

</details>
<details>
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
<summary>리플렉션에 대해 설명해주세요.</summary>

<br/>

구체적인 클래스 타입을 알지 못해도 그 클래스의 정보(메소드, 타입, 변수, ...) 에 접근할 수 있게 해주는 기법입니다. 리플렉션은 객체를 통해 클래스의 정보를 분석하여 런타임에 클래스의 동작으로 검사하거나 조작할 수 있습니다. 리플렉션은 런타임에 동작하기 때문에, 컴파일 시점에서 오류를 잡을 수 없다는 단점이 존재하므로 사용에 유의해야합니다.

<details>
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
<summary>StringBuilder 와 StringBuffer 의 차이에 대해 설명해주세요</summary>

<br/>

StringBuilder와 StringBuffer는 내부에서 char[] 배열을 이용해 가변 문자열을 처리하는 클래스입니다. 주요 차이점은 동기화 여부입니다. StringBuilder 는 동기화를 지원하지 않는 반면, StringBuffer는 메서드는 synchronized 키워드로 동기화를 지원하기 때문에 멀티스레드 환경에서 안전하게 동작할 수 있습니다. 성능상으로는 StringBuilder 가 동기화가 없으므로 더 빠르게 동작합니다.

<br/>

<details>
<summary>꼬리질문1: 왜 동기화(synchronized)가 걸려 있으면 느릴까요?</summary>

<br/>
동기화가 성능에 영향을 미치는 이유는 synchronized 키워드로 인해 자바의 모니터 락(monitor lock) 메커니즘이 동작하기 때문입니다. 동기화된 메서드나 블록에 접근하려면 스레드가 락을 먼저 획득해야 하며, 이 과정에서 락 획득(lock acquisition)과 락 해제(lock release)에 따른 추가적인 연산이 발생합니다. 특히, 멀티스레드 환경에서 여러 스레드가 동시에 같은 자원에 접근할 경우, 락 경쟁(lock contention) 이 발생하여 스레드가 대기하는 시간이 길어지고 성능이 저하됩니다. 또한, 스레드 간 컨텍스트 스위칭(context switching), 캐시 미스(cache miss) 와 같은 운영체제 수준의 오버헤드가 발생해 성능에 부정적인 영향을 미칠 수 있습니다.

</details>
 
<details>
<summary>꼬리질문2: 싱글 스레드로 접근한다는 가정하에선 StringBuilder 와 StringBuffer 의 성능이 똑같을까요?</summary>

<br/>
싱글 스레드 환경이라도 StringBuffer 는 동기화된 메서드를 사용하기 때문에 동기화 메커니즘에 따른 락 획득과 해제 비용아 발생합니다. 이러한 비용은 불필요한 오버헤드로 작용하여 성능이 저하됩니다. 반면, StringBuilder는 동기화되지 않아 추가적인 락 처리 과정이 없으므로, 싱글스레드 환경에서도 StringBuilder 가 StringBuffer 보다 성능이 더 빠릅니다.

<br/>

</details>

<br/>

</details>

<details>
<summary>Garbage Collection과 Garbage Collector의 차이를 설명해주세요.</summary>

<br/>

가비지 콜렉션은 JVM에서 Heap 영역에 동적으로 할당했던 메모리 중, 더 이상 사용하지 않는 객체들, 메모리를 자동으로 찾아 해제하는 프로세스입니다. 이를 통해 개발자가 명시적으로 메모리를 해제하지 않아도, 메모리를 안전하게 관리할 수 있습니다. 가비지 콜렉터는 이러한 작업, 즉 가비지 컬렉션을 수행하는 시스템의 구성 요소입니다.

<br/>

<details>
<summary>꼬리질문1: 그렇다면 개발자는 가비지콜렉터만 믿고 메모리를 신경쓰지 않아도 되는 것인가요?</summary>

<br/>

그것은 아닙니다. 가비지 컬렉션에도 단점이 존재하는데요. 자동으로 할당 해제를 해준다고 해도, 메모리가 정확히 언제 해제되는지 알 수가 없고, 이를 제어할 수 없습니다. 또한 가비지 컬렉션을 하는 동안은 다른 동작을 멈춰 오버헤드가 발생하는 문제점이 존재합니다.(이를 Stop-The-World, STW라고 합니다. 과거 익스플로러가 악명이 높았던 이유가 잦은 GC 때문이라고 해요.)

</details>

<details>
<summary>꼬리질문2: 그렇다면 heap의 구조에 대해서 설명해주세요.</summary>

<br/>

Heap에는 Young영역과 Old영역이 있는데요. Young은 Eden과 Survivor0,1영역으로 나뉩니다. 대부분의 새롭게 생성된 객체는 Young, 특히 Eden에 위치합니다. 여기서 GC가 한번 발생한 후에 살아있는 객체는 Survivor0, Survivor영역이 가득 차게 되면 그 중에서 살아남은 객체를 다른 Survivor로 옮기고 기존 영역은 비웁니다. 이 과정을 반복하면서 살아남아 age가 임계값에 도달한 객체는 Old영역으로 이동하게 됩니다.

</details>

<details>
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
<summary>자바의 Wrapper 클래스는 무엇이며, 왜 사용하나요?</summary>

<br/>

Wrapper 클래스는 기본 데이터타입을 객체로 다루기 위해 자바에서 제공하는 클래스입니다. 기본 타입은 객체가 아니기 때문에 객체가 필요한 경우 Wrapper 타입을 사용합니다. 예를 들어,컬렉션과 같은 객체만 취급하는 구조에서 Wrapper 클래스를 사용해 기본 타입을 객체로 래핑해서 사용할 수 있습니다.

<br/>

</details>

<details>
<summary>자바에서 오토박싱과 오토언박싱에 대해 설명해주세요</summary>

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
<summary>기본타입과 래퍼타입의 차이점과 어떤 경우에 기본 타입을 사용해야 할 지 설명해 주세요</summary>

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
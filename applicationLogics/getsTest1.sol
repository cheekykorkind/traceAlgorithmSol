	// 어떤 형태의 function이 React Native에서 값을 받을수 있는지 테스트한다.
	// debugger-ui : BigNumber {s: 1, e: 1, c: Array(1)} 형태로 return 받은것을 확인함.
	// React Native : result.c[0] 형식으로 값을 받아올수 있음.
contract Simple {
    uint storedData;

    function set(uint x) {
        storedData = x;
    }

    function get() constant returns (uint) {
        return storedData;
    }
}


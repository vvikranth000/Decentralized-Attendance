pragma solidity ^0.4.18;

contract Owned 
{
    address owner;
    
    function Owned() public 
    {
        owner = msg.sender;
    }
    
   modifier onlyOwner 
   {
       require(msg.sender == owner);
       _;
   }
}

contract AttendanceSheet is Owned 
{
    
    struct Student 
    {
        uint age;
        bytes32 fName;
        bytes32 lName;
        uint attendanceValue;
    }
    
    mapping (uint => Student) studentList;
    uint[] public studIdList;
    
    event studentCreationEvent(
       bytes32 fName,
       bytes32 lName,
       uint age
    );
    
    function stringToBytes32(string memory source) public pure returns (bytes32 result) 
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) 
        {
            return 0x0;
        }
    
        assembly 
        {
            result := mload(add(source, 32))
        }
    }
    
    function bytes32ToString(bytes32 x) public pure returns (string) 
    {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) 
        {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) 
        {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
    
    function createStudent(uint _studId, uint _age, string _fName, string _lName) onlyOwner public 
    {
        var student = studentList[_studId];
        
        student.age = _age;
        student.fName = stringToBytes32(_fName);
        student.lName = stringToBytes32(_lName);
        student.attendanceValue = 0;
        studIdList.push(_studId) -1;
        studentCreationEvent(stringToBytes32(_fName), stringToBytes32(_lName), _age);
    }
    
    function incrementAttendance(uint _studId) onlyOwner public {
        studentList[_studId].attendanceValue = studentList[_studId].attendanceValue+1;
    }
    
    function getStudents() view public returns(uint[]) {
        return studIdList;
    }
    
    function getParticularStudent(uint _studId) public view returns (string, string, uint, uint) {
        return (bytes32ToString(studentList[_studId].fName), bytes32ToString(studentList[_studId].lName), studentList[_studId].age, studentList[_studId].attendanceValue);
    }

    function countStudents() view public returns (uint) {
        return studIdList.length;
    }
    
}

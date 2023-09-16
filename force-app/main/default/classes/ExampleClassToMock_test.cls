@IsTest
public with sharing class ExampleClassToMock_test 
{    
    @IsTest
    static void mockTest()
    {
        //Creating an instance ov v_ApexMocking Class
        v_ApexMocking mocks = new v_ApexMocking();
        //Creating an mock instance of ExampleClassToMock
        ExampleClassToMock mockInstanceOfExampleClassToMock = (ExampleClassToMock) mocks.mock(ExampleClassToMock.class);
        //startStubbing() and stopStubbing() is important to record arguments for matching later on
        mocks.startStubbing();
        /**
         * mocking getName(Integer) method from ExampleClassToMock and throwing an exception this will help in covering catches
         * Line number 19 records the argument 2 for getName method and returns or throw when the same method id called with same arguments
         * See line number 26 it will throw an error, Similarly line 29 will return 'Tarak Das' when getName('Tarak') is called in the actual Code
         * NOTE:- Argument asertion is case sensitive  
         */
        mocks.when(mockInstanceOfExampleClassToMock.getName(2)).thenThrow(new NullPointerException());
        mocks.when(mockInstanceOfExampleClassToMock.getName('Tarak')).thenReturn('Tarak Das');
        mocks.when(mockInstanceOfExampleClassToMock.getName('Tarak', 'Das')).thenReturn('Tarak 2 parems Das');
        mocks.when(mockInstanceOfExampleClassToMock.getUsers()).thenReturn(new List<User>{new User(LastName = 'Mock User')});
        mocks.stopStubbing();
        v_ApexMockRouter.setMock(mockInstanceOfExampleClassToMock, TestClassToMock.Class);
        try {
            System.debug(ExampleClassToMock.newInstance().getName(2));
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        System.debug(ExampleClassToMock.newInstance().getName('Tarak'));
        System.debug(ExampleClassToMock.newInstance().getName('Tarak', 'Das'));
        System.debug(ExampleClassToMock.newInstance().getName('Tarak', 'das'));
        System.debug(ExampleClassToMock.newInstance().getName('Tarak', null));
        System.debug(ExampleClassToMock.newInstance().getUsers());
    }

    @IsTest
    static void testWithoutMock()
    {
        ExampleClassToMock obj = ExampleClassToMock.newInstance();
        obj.getName('Me');
        obj.getName('me', 'myself');
        obj.getName(5);
        obj.getUsers();
    }
}
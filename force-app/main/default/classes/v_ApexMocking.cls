@isTest
public with sharing class v_ApexMocking implements System.StubProvider 
{
    private Boolean isStubbing = false;
    private Map<String, Map<List<Object>, Object>> methodVsArgumentVsReturnVal = new Map<String, Map<List<Object>, Object>>();
    private List<Object> currentArgs; 
    private String currentMethod; 
    private ReturnValueRecorder that = new ReturnValueRecorder(this); 

    public Object mock(Type t) 
    {
        return Test.createStub(t, this);
    }

    public void startStubbing() 
    {
        this.isStubbing = true;    
    }

    public void stopStubbing() 
    {
        this.isStubbing = false;    
    }

    public ReturnValueRecorder when(Object ingnoredReturnvalues) 
    {
        return that;    
    }

    public class ReturnValueRecorder 
    {    
        private v_ApexMocking that;
        
        ReturnValueRecorder(v_ApexMocking that) 
        {
            this.that = that;
        }

        public void thenReturn(Object returnValue) 
        {
            processRequest(returnValue);
        }

        public void thenThrow(Exception ex) 
        {
            processRequest(ex);
        }

        private void processRequest(Object returnValue) 
        {
            if (!that.methodVsArgumentVsReturnVal.containsKey(that.currentMethod)) {
                that.methodVsArgumentVsReturnVal.put(that.currentMethod, new Map<List<Object>,Object>());
            }
            that.methodVsArgumentVsReturnVal.get(that.currentMethod).put(that.currentArgs, returnValue);
            that.currentArgs = null;
            that.currentMethod = null;   
        }
    }

    private String getUniqueMethodName(Object stub, String methodName, List<System.Type> listOfParamTypes) 
    {
        return (stub + '').substringBefore(':[stubProvider=v_ApexMocking:') + ':[stubProvider=v_ApexMocking:' + methodName + listOfParamTypes;  
    }

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, System.Type returnType, List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs)
    {
        String unniqueMethodName = getUniqueMethodName(stubbedObject, stubbedMethodName, listOfParamTypes);
        if (isStubbing) 
        {
            currentMethod = unniqueMethodName;
            currentArgs = listOfArgs;
            return null;    
        }
        Object returnValue = methodVsArgumentVsReturnVal.get(unniqueMethodName)?.get(listOfArgs);
        if (returnValue instanceOf Exception) 
        {
            throw (Exception) returnValue;    
        }
        return returnValue;
    }
}
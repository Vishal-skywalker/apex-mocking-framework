@isTest
public with sharing class v_MockUtils 
{
    private static Integer fakeIdCount = 0;
	private static final String ID_PATTERN = '000000000000';

	/**
	 * Generate a fake Salesforce Id for the given SObjectType
	 */
	public static Id generateId(Schema.SObjectType sobjectType)
	{
		String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
		fakeIdCount++;
		String fakeIdPrefix = ID_PATTERN.substring(0, 12 - fakeIdCount.format().length());
		return Id.valueOf(keyPrefix + fakeIdPrefix + fakeIdCount);
	}

    /**
     * lets us set formula and other readonly fields for testing 
     */
    public static SObject setReadOnlyFields(SObject o, Type t, Map<String,Object> fieldVsDataMap) 
    {
        if (o != null) 
        {
            fieldVsDataMap.putAll(o.getPopulatedFieldsAsMap());
        }
        return (SObject) JSON.deserialize(JSON.serialize(fieldVsDataMap), t);
    }

    public static SObject setReadOnlyFields(Type t, Map<String,Object> fieldVsDataMap) 
    {
        return setReadOnlyFields(null, t, fieldVsDataMap);
    }

    /**
     * This method is used to create data to mock subQueries
     * Example: v_MockUtils.populateChildren(
     *              new Account(Name = 'Vishal'), 
     *              new List<SObject>{new Contact(LastName = 'Contact 1'), new Contact(LastName = 'Contact 2')},
     *              'Contacts');
     * NOTE:- children doesnot show up when you print it directly but they are accesable in the code.
     */
    public static SObject populateChildren(SObject parent, List<SObject> children, String childRelationshipName) 
    {
        JSONGenerator gen = JSON.createGenerator(true);
        createJson(gen, parent, children, childRelationshipName);
        return (SObject) JSON.deserialize(gen.getAsString(), SObject.Class);
    }

    private static void createJson(JSONGenerator gen, SObject parent, List<SObject> children, String childRelationshipName) 
    {
        Map<String, Object> parentDataMap = parent.getPopulatedFieldsAsMap();
        gen.writeStartObject();
        gen.writeFieldName('attributes');
        gen.writeStartObject();
        gen.writeStringField('type', parent.getSObjectType().getDescribe().getName());
        gen.writeEndObject();
        for(String fieldName : parentDataMap.keySet())
        {
            gen.writeObjectField(fieldName, parentDataMap.get(fieldName));    
        }
        if (children != null) 
        {
            gen.writeFieldName(childRelationshipName);
            gen.writeStartObject();
            gen.writeNumberField('totalSize', children.size());
            gen.writeBooleanField('done', true);
            gen.writeFieldName('records');
            gen.writeStartArray();
            for (SObject s : children) 
            {
                createJson(gen, s, null, null); 
            }
            gen.writeEndArray();    
        }
        gen.writeEndObject();
    }
}
Class User.SQLvar
{

ClassMethod GetJSON(json As %String, name As %String) As %String(MAXLEN="") [ SqlName = GetJSON, SqlProc ]
{

    quit:(json="") ""

    set dyna = {}.%FromJSON(json)

    set result = dyna.%Get(name)

    quit $s(result'="":$s(($classname(result)="%Library.DynamicObject")||($classname(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(name,result,dyna.%GetTypeOf(name)).%ToJSON()),1:"")
}

ClassMethod GetProp(json As %String, prop As %String) As %String(MAXLEN="") [ SqlName = GetProp, SqlProc ]
{
    quit:(json="") ""

    set dyna = {}.%FromJSON(json)

    Quit dyna.%Get(prop)
}

ClassMethod GetAtJSON(json As %String, position As %Integer) As %String(MAXLEN="") [ SqlName = GetAtJSON, SqlProc ]
{
    quit:(json="") ""

    set dyna = [].%FromJSON(json)
    
    set i = 0
    set iterator = dyna.%GetIterator()
    
    while iterator.%GetNext(.key, .result) {
        quit:(i=position) 
        do $Increment(i)
    }

    Quit $s(result'="":$s(($classname(result)="%Library.DynamicObject")||($classname(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(key,result,dyna.%GetTypeOf(key)).%ToJSON()),1:"")
}

}

# Problem

Mod ceased to function because attempting to index an integer value.

## Faulty code

```
    return Random(1, #rangemax)
```

## Correct code

```
    return Random(1, rangemax)
```

## Analysis, why wrong?

* just before was manipulating tables while modifying previous function
getNameForKaboom()
* variable name didn't ring a bell
* not caught by linter or typing (because lua has no static type declarations)

## Action to learn or to foolproof

todo: foolproof by using type-hinting variable names: iRangeMax, aWandNames

## Tags


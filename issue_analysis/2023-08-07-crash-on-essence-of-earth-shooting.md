# Problem

When Essence of Earth started shooting, the game crashed hard.

## Faulty code

```
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * damagemodifier
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
```

## Correct code

```
			for _, sExplType in pairs(aExplTypes) do
				local fExplValue = ComponentObjectGetValue2(iProjectile, "config_explosion", sExplType)
				if (fExplValue ~= nil) then
					-- game may crash if value is not an integer
					fExplValue = math.floor(fExplValue * fExplosionModifier)
					ComponentObjectSetValue2(iProjectile, "config_explosion", sExplType, fExplValue)
				end
			end
```

## Analysis, why wrong?

* ComponentObjectGetValue and ComponentObjectSetValue are deprecated
* One of these fields MUST be an integer, or else, crash happens

## Action to learn or to foolproof

foolproofing: remove these two functions from the linter whitelist, and all
other deprecated functions to get editor warnings.
✅ done on 2023-08-07

## Tags


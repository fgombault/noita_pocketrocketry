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
			local damage_by_types = ComponentObjectGetMembers(projectile, "damage_by_type") or {};
			for i, damageByTypeComp in ipairs(damage_by_types) do
				for a, b in ipairs(dtypes) do
					local v = ComponentGetValue2(damageByTypeComp, b)
					v = v * damagemodifier
					ComponentSetValue2(damageByTypeComp, b, v)
				end
			end

```

## Analysis, why wrong?

* ComponentObjectGetValue and ComponentObjectSetValue are deprecated
* the "damage_by_type" subcomponent didn't exist on that particular shot effect

## Action to learn or to foolproof

foolproofing: remove these two functions from the linter whitelist, and all
other deprecated functions to get editor warnings.
✅ done on 2023-08-07

## Tags


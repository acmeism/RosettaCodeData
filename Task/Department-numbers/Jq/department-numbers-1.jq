def check(fire; police; sanitation):
    (fire != police) and (fire != sanitation) and (police != sanitation)
    and (fire + police + sanitation == 12)
    and (police % 2 == 0);

range(1;8) as $fire
| range(1;8) as $police
| range(1;8) as $sanitation
| select( check($fire; $police; $sanitation) )
| {$fire, $police, $sanitation}

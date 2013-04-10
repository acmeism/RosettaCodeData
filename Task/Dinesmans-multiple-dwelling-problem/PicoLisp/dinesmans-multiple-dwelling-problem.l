# Problem statement
(be dwelling (@Tenants)
   (permute (Baker Cooper Fletcher Miller Smith) @Tenants)
   (not (topFloor Baker @Tenants))
   (not (bottomFloor Cooper @Tenants))
   (not (or ((topFloor Fletcher @Tenants)) ((bottomFloor Fletcher @Tenants))))
   (higherFloor Miller Cooper @Tenants)
   (not (adjacentFloor Smith Fletcher @Tenants))
   (not (adjacentFloor Fletcher Cooper @Tenants)) )

# Utility rules
(be topFloor (@Tenant @Lst)
   (equal (@ @ @ @ @Tenant) @Lst) )

(be bottomFloor (@Tenant @Lst)
   (equal (@Tenant @ @ @ @) @Lst) )

(be higherFloor (@Tenant1 @Tenant2 @Lst)
   (append @ @Rest @Lst)
   (equal (@Tenant2 . @Higher) @Rest)
   (member @Tenant1 @Higher) )

(be adjacentFloor (@Tenant1 @Tenant2 @Lst)
   (append @ @Rest @Lst)
   (or
      ((equal (@Tenant1 @Tenant2 . @) @Rest))
      ((equal (@Tenant2 @Tenant1 . @) @Rest)) ) )

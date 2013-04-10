(de *Buckets . 15)  # Number of buckets

# E/R model
(class +Bucket +Entity)
(rel key (+Key +Number))  # Key  1 .. *Buckets
(rel val (+Number))       # Value 1 .. 999


# Start with an empty DB
(call 'rm "-f" "buckets.db")  # Remove old DB (if any)
(pool "buckets.db")           # Create new DB file


# Create *Buckets buckets with values between 1 and 999
(for K *Buckets
   (new T '(+Bucket)  'key K  'val (rand 1 999)) )
(commit)


# Pick a random bucket
(de pickBucket ()
   (db 'key '+Bucket (rand 1 *Buckets)) )


# First process
(unless (fork)
   (seed *Pid)  # Ensure local random sequence
   (loop
      (let (B1 (pickBucket)  B2 (pickBucket))  # Pick two buckets 'B1' and 'B2'
         (dbSync)                              # Atomic DB operation
         (let (V1 (; B1 val)  V2 (; B2 val))   # Get current values
            (cond
               ((> V1 V2)
                  (dec> B1 'val)               # Make them closer to equal
                  (inc> B2 'val) )
               ((> V2 V1)
                  (dec> B2 'val)
                  (inc> B1 'val) ) ) )
         (commit 'upd) ) ) )                   # Close transaction

# Second process
(unless (fork)
   (seed *Pid)  # Ensure local random sequence
   (loop
      (let (B1 (pickBucket)  B2 (pickBucket))  # Pick two buckets 'B1' and 'B2'
         (unless (== B1 B2)                    # Found two different ones?
            (dbSync)                              # Atomic DB operation
            (let (V1 (; B1 val)  V2 (; B2 val))   # Get current values
               (cond
                  ((> V1 V2 0)
                     (inc> B1 'val)               # Redistribute them
                     (dec> B2 'val) )
                  ((> V2 V1 0)
                     (inc> B2 'val)
                     (dec> B1 'val) ) ) )
            (commit 'upd) ) ) ) )                 # Close transaction

# Third process
(unless (fork)
   (loop
      (dbSync)                         # Atomic DB operation
      (let Lst (collect 'key '+Bucket) # Get all buckets
         (for This Lst                 # Print current values
            (printsp (: val)) )
         (prinl                        # and total sum
            "-- Total: "
            (sum '((This) (: val)) Lst) ) )
      (rollback)
      (wait 2000) ) )                  # Sleep two seconds

(wait)

(defun random_base ()
    (random 4))

(defun basechar (base)
    (char "ACTG" base))

(defun generate_genome (genome_length)
    (let (genome '())
        (loop for i below genome_length do
            (push (random_base) genome))
        (return-from generate_genome genome)))

(defun map_genome (genome)
    (let (seq '())
        (loop for n from (1- (length genome)) downto 0 do
            (push (position (char genome n) "ACTG") seq))
        seq))

(defun output_genome_info (genome &optional (genome_name "ORIGINAL"))
    (let ((ac 0) (tc 0) (cc 0) (gc 0))
        (format t "~%           ---- ~a ----" genome_name)
        (do ((n 0 (1+ n)))
            ((= n (length genome)))
            (when (= 0 (mod n 50)) (format t "~& ~4d: " (1+ n)))
            (case (nth n genome)
                (0 (incf ac))
                (1 (incf tc))
                (2 (incf cc))
                (3 (incf gc)))
            (format t "~c" (basechar (nth n genome))))
            (format t "~2%- Total : ~3d~%A : ~d   C : ~d~%T : ~d   G : ~d~2%" (length genome) ac tc cc gc)))

(defun insert_base (genome)
    (let ((place (random (length genome)))
        (base (random_base)))
        (format t "Insert      +  ~c   at   ~3d~%"
            (basechar base) (+ 1 place))
        (if (= 0 place)
            (push base genome)
            (push base (cdr (nthcdr (1- place) genome))))
        (return-from insert_base genome)))

(defun swap_base (genome)
    (let ((place (random (length genome)))
        (base (random_base)))
        (format t "Swap      ~c -> ~c   at   ~3d~%"
            (basechar (nth place genome)) (basechar base) (+ 1 place))
        (setf (nth place genome) base)
        (return-from swap_base genome)))

(defun delete_base (genome)
    (let ((place (random (length genome))))
        (format t "Delete      -  ~c   at   ~3d~%"
            (basechar (nth place genome)) (+ 1 place))
        (if (= 0 place) (pop genome)
        (pop (cdr (nthcdr (1- place) genome))))
        (return-from delete_base genome)))

(defun mutate (genome_length n_mutations
    &key (ins_w 10) (swp_w 10) (del_w 10)
        (genome (generate_genome genome_length) has_genome))
    (if has_genome (setf genome (map_genome genome)))
    (output_genome_info genome)
    (format t "      ---- MUTATION SEQUENCE ----~%")
    (do ((n 0 (1+ n)))
        ((= n n_mutations))
        (setf mutation_type (random (+ ins_w swp_w del_w)))
        (format t "~3d : " (1+ n))
        (setf genome
            (cond ((< mutation_type ins_w) (insert_base genome))
                ((< mutation_type (+ ins_w swp_w)) (swap_base genome))
                (t (delete_base genome)))))
    (output_genome_info genome "MUTATED"))

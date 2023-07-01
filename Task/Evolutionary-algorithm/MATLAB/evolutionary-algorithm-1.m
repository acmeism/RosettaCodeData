%This class impliments a string that mutates to a target
classdef EvolutionaryAlgorithm

    properties

        target;
        parent;
        children = {};
        validAlphabet;

        %Constants
        numChildrenPerIteration;
        maxIterations;
        mutationRate;

    end

    methods

        %Class constructor
        function family = EvolutionaryAlgorithm(target,mutationRate,numChildren,maxIterations)

            family.validAlphabet = char([32 (65:90)]); %Space char and A-Z
            family.target = target;
            family.children = cell(numChildren,1);
            family.numChildrenPerIteration = numChildren;
            family.maxIterations = maxIterations;
            family.mutationRate = mutationRate;
            initialize(family);

        end %class constructor

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Helper functions and class get/set functions
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %setAlphabet() - sets the valid alphabet for the current instance
        %of the EvolutionaryAlgorithm class.
        function setAlphabet(family,alphabet)

            if(ischar(alphabet))
                family.validAlphabet = alphabet;

                %Makes change permanent
                assignin('caller',inputname(1),family);
            else
                error 'New alphabet must be a string or character array';
            end

        end

        %setTarget() - sets the target for the current instance
        %of the EvolutionaryAlgorithm class.
        function setTarget(family,target)

            if(ischar(target))
                family.target = target;

                %Makes change permanent
                assignin('caller',inputname(1),family);
            else
                error 'New target must be a string or character array';
            end

        end

        %setMutationRate() - sets the mutation rate for the current instance
        %of the EvolutionaryAlgorithm class.
        function setMutationRate(family,mutationRate)

            if(isnumeric(mutationRate))
                family.mutationRate = mutationRate;

                %Makes change permanent
                assignin('caller',inputname(1),family);
            else
                error 'New mutation rate must be a double precision number';
            end

        end

        %setMaxIterations() - sets the maximum number of iterations during
        %evolution for the current instance of the EvolutionaryAlgorithm class.
        function setMaxIterations(family,maxIterations)

            if(isnumeric(maxIterations))
                family.maxIterations = maxIterations;

                %Makes change permanent
                assignin('caller',inputname(1),family);
            else
                error 'New maximum amount of iterations must be a double precision number';
            end

        end

        %display() - overrides the built-in MATLAB display() function, to
        %display the important class variables
        function display(family)
            disp([sprintf('Target: %s\n',family.target)...
                  sprintf('Parent: %s\n',family.parent)...
                  sprintf('Valid Alphabet: %s\n',family.validAlphabet)...
                  sprintf('Number of Children: %d\n',family.numChildrenPerIteration)...
                  sprintf('Mutation Rate [0,1]: %d\n',family.mutationRate)...
                  sprintf('Maximum Iterations: %d\n',family.maxIterations)]);
        end

        %disp() - overrides the built-in MATLAB disp() function, to
        %display the important class variables
        function disp(family)
            display(family);
        end

        %randAlphabetElement() - Generates a random character from the
        %valid alphabet for the current instance of the class.
        function elements = randAlphabetElements(family,numChars)

            %Sample the valid alphabet randomly from the uniform
            %distribution
            N = length(family.validAlphabet);
            choices = ceil(N*rand(1,numChars));

            elements = family.validAlphabet(choices);

        end

        %initialize() - Sets the parent to a random string of length equal
        %to the length of the target
        function parent = initialize(family)

            family.parent = randAlphabetElements(family,length(family.target));
            parent = family.parent;

            %Makes changes to the instance of EvolutionaryAlgorithm permanent
            assignin('caller',inputname(1),family);

        end %initialize

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Functions required by task specification
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %mutate() - generates children from the parent and mutates them
        function mutate(family)

            sizeParent = length(family.parent);

            %Generate mutatant children sequentially
            for child = (1:family.numChildrenPerIteration)

                parentCopy = family.parent;

                for charIndex = (1:sizeParent)
                    if (rand(1) < family.mutationRate)
                        parentCopy(charIndex) = randAlphabetElements(family,1);
                    end
                end

                family.children{child} = parentCopy;

            end

            %Makes changes to the instance of EvolutionaryAlgorithm permanent
            assignin('caller',inputname(1),family);

        end %mutate

        %fitness() - Computes the Hamming distance between the target
        %string and the string input as the familyMember argument
        function theFitness = fitness(family,familyMember)

            if not(ischar(familyMember))
                error 'The second argument must be a string';
            end

            theFitness = sum(family.target == familyMember);
        end

        %evolve() - evolves the family until the target is reached or it
        %exceeds the maximum amount of iterations
        function [iteration,mostFitFitness] = evolve(family)

            iteration = 0;
            mostFitFitness = 0;
            targetFitness = fitness(family,family.target);

            disp(['Target fitness is ' num2str(targetFitness)]);

            while (mostFitFitness < targetFitness) && (iteration < family.maxIterations)

                iteration = iteration + 1;

                mutate(family);

                parentFitness = fitness(family,family.parent);
                mostFit = family.parent;
                mostFitFitness = parentFitness;

                for child = (1:family.numChildrenPerIteration)

                    childFitness = fitness(family,family.children{child});
                    if childFitness > mostFitFitness
                        mostFit = family.children{child};
                        mostFitFitness = childFitness;
                    end

                end

                family.parent = mostFit;
                disp([num2str(iteration) ': ' mostFit ' - Fitness: ' num2str(mostFitFitness)]);

            end

            %Makes changes to the instance of EvolutionaryAlgorithm permanent
            assignin('caller',inputname(1),family);

        end %evolve

    end %methods
end %classdef

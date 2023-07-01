/**
 * kmeans module
 *
 *   cluster(model, k, converged = assignmentsConverged)
 *   distance(p, q),
 *   distanceSquared(p, q),
 *   centroidsConverged(delta)
 *   assignmentsConverged(model, newModel)
 *   assignmentsToClusters(model)
 */
define(function () {
    "use strict";

    /**
     * @public
     * Calculate the squared distance between two vectors.
     *
     * @param [number] p vector with same dimension as q
     * @param [number] q vector with same dimension as p
     * @return {number} the distance between p and q squared
     */
    function distanceSquared(p, q) {
        const d = p.length; // dimension of vectors

        if(d !== q.length) throw Error("p and q vectors must be the same length")

        let sum = 0;
        for(let i = 0; i < d; i += 1) {
            sum += (p[i] - q[i])**2
        }
        return sum;
    }

    /**
     * @public
     * Calculate the distance between two vectors of the same dimension.
     *
     * @param [number] p vector of same dimension as q
     * @param [number] q vector of same dimension as p
     * @return the distance between vectors p and q
     */
    function distance(p, q) {
        return Math.sqrt(distanceSquared(p, q));
    }

    /**
     * @private
     * find the closest centroid for the given observation and return it's index.
     *
     * @param [[number]] centroids - array of k vectors, each vector with same dimension as observations.
     *                               these are the center of the k clusters
     * @param [[number]] observation - vector with same dimension as centroids.
     *                                 this is the observation to be clustered.
     * @return {number} the index of the closest centroid in centroids
     */
    function findClosestCentroid(centroids, observation) {
        const k = centroids.length; // number of clusters/centroids

        let centroid = 0;
        let minDistance = distance(centroids[0], observation);
        for(let i = 1; i < k; i += 1) {
            const dist = distance(centroids[i], observation);
            if(dist < minDistance) {
                centroid = i;
                minDistance = dist;
            }
        }
        return centroid;
    }

    /**
     * @private
     * Calculate the centroid for the given observations.
     * This takes the average of all observations (at each dimension).
     * This average vector is the centroid for those observations.
     *
     * @param [[number]] observations - array of observations (each observatino is a vectors)
     * @return [number] centroid for given observations (vector of same dimension as observations)
     */
    function calculateCentroid(observations) {
        const n = observations.length;      // number of observations
        const d = observations[0].length;   // dimension of vectors

        // create zero vector of same dimension as observation
        let centroid = [];
        for(let i = 0; i < d; i += 1) {
            centroid.push(0.0);
        }

        //
        // sum all observations at each dimension
        //
        for(let i = 0; i < n; i += 1) {
            //
            // add the observation to the sum vector, element by element
            // to prepare to calculate the average at each dimension.
            //
            for(let j = 0; j < d; j += 1) {
                centroid[j] += observations[i][j];
            }
        }

        //
        // divide each dimension by the number of observations
        // to create the average vector.
        //
        for(let j = 0; j < d; j += 1) {
            centroid[j] /= n;
        }

        return centroid;
    }

    /**
     * @private
     * calculate the cluster assignments for the observations, given the centroids.
     *
     * @param [[number]] centroids - list of vectors with same dimension as observations
     * @param [[number]] observations - list of vectors with same dimension as centroids
     * @return [number] list of indices into centroids; one per observation.
     */
    function assignClusters(centroids, observations) {
        const n = observations.length;  // number of observations

        const assignments = [];
        for(let i = 0; i < n; i += 1) {
            assignments.push(findClosestCentroid(centroids, observations[i]));
        }

        return assignments; // centroid index for each observation
    }

    /**
     * @private
     * calculate one step of the k-means algorithm;
     * - assign each observation to the nearest centroid to create clusters
     * - calculate a new centroid for each cluster given the observations in the cluster.
     *
     * @param [[number]] centroids - list of vectors with same dimension as observations
     * @param [[number]] observations - list of vectors with same dimension as centroids
     * @return a new model with observations, centroids and assignments
     */
    function kmeansStep(centroids, observations) {
        const k = centroids.length; // number of clusters/centroids

        // assign each observation to the nearest centroid to create clusters
        const assignments = assignClusters(centroids, observations); // array of cluster indices that correspond observations

        // calculate a new centroid for each cluster given the observations in the cluster
        const newCentroids = [];
        for(let i = 0; i < k; i += 1) {
            // get the observations for this cluster/centroid
            const clusteredObservations = observations.filter((v, j) => assignments[j] === i);

            // calculate a new centroid for the observations
            newCentroids.push(calculateCentroid(clusteredObservations));
        }
        return {'observations': observations, 'centroids': newCentroids, 'assignments': assignments }
    }

    /**
     * @public
     * Run k-means on the given model until each centroid converges to with the given delta
     * The initial model is NOT modified by the algorithm, rather a new model is returned.
     *
     * @param {*} model - object with
     *                    observations: array, length n, of data points; each datapoint is
     *                                  itself an array of numbers (a vector).
     *                                  The length each datapoint (d) vector should be the same.
     *                    centroids: array of data points.
     *                               The length of the centroids array indicates the number of
     *                               of desired clusters (k).
     *                               each datapoint is array (vector) of numbers
     *                               with same dimension as the datapoints in observations.
     *                    assignments: array of integers, one per observation,
     *                                 with values 0..centroids.length - 1
     * @param number delta - the maximum difference between each centroid in consecutive runs for convergence
     * @return {*} - result with
     *               model: model, as described above, with updated centroids and assignments,
     *               iterations: number of iterations,
     *               durationMs: elapsed time in milliseconds
     */
    function kmeans(model, maximumIterations = 200, converged = assignmentsConverged) {
        const start = new Date();

        // calculate new centroids and cluster assignments
        let newModel = kmeansStep(model.centroids, model.observations);

        // continue until centroids do not change (within given delta)
        let i = 0;
        while((i < maximumIterations) && !converged(model, newModel)) {
            model = newModel;   // new model is our model now
            // console.log(model);

            // calculate new centroids and cluster assignments
            newModel = kmeansStep(model.centroids, model.observations);
            i += 1;
        }

        // console.log(newModel);
        const finish = new Date();
        return {'model': newModel, 'iterations': i, 'durationMs': (finish.getTime() - start.getTime())};
    }

    /**
     * @public
     * Return a function that determines convergence based on the centroids.
     * If two consecutive sets of centroids remain within a given delta,
     * then the algorithm is converged.
     *
     * @param number delta, the maximum difference between each centroid in consecutive runs for convergence
     * @return function to use as the converged function in kmeans call.
     */
    function centroidsConverged(delta) {
        /**
         * determine if two consecutive set of centroids are converged given a maximum delta.
         *
         * @param [[number]] centroids - list of vectors with same dimension as observations
         * @param [[number]] newCentroids - list of vectors with same dimension as observations
         * @param number delta - the maximum difference between each centroid in consecutive runs for convergence
         */
        return function(model, newModel) {
            const centroids = model.centroids;
            const newCentroids = newModel.centroids;

            const k = centroids.length; // number of clusters/centroids
            for(let i = 0; i < k; i += 1) {
                if(distance(centroids[i], newCentroids[i]) > delta) {
                    return false;
                }
            }

            return true;
        }
    }

    /**
     * @public
     * determine if two consecutive set of clusters are converged;
     * the clusters are converged if the cluster assignments are the same.
     *
     * @param {*} model - object with observations, centroids, assignments
     * @param {*} newModel - object with observations, centroids, assignments
     * @param number delta - the maximum difference between each centroid in consecutive runs for convergence
     */
    function assignmentsConverged(model, newModel) {
        function arraysEqual(a, b) {
            if (a === b) return true;
            if (a === undefined || b === undefined) return false;
            if (a === null || b === null) return false;
            if (a.length !== b.length) return false;

            // If you don't care about the order of the elements inside
            // the array, you should sort both arrays here.

            for (var i = 0; i < a.length; ++i) {
            if (a[i] !== b[i]) return false;
            }
            return true;
        }

        return arraysEqual(model.assignments, newModel.assignments);
    }

    /**
     * Use the model assignments to create
     * array of observation indices for each centroid
     *
     * @param {object} model with observations, centroids and assignments
     * @reutrn [[number]] array of observation indices for each cluster
     */
    function assignmentsToClusters(model) {
        //
        // put offset of each data points into clusters using the assignments
        //
        const n = model.observations.length;
        const k = model.centroids.length;
        const assignments = model.assignments;
        const clusters = [];
        for(let i = 0; i < k; i += 1) {
            clusters.push([])
        }
        for(let i = 0; i < n; i += 1) {
            clusters[assignments[i]].push(i);
        }

        return clusters;
    }


    //
    // return public methods
    //
    return {
        'cluster': kmeans,
        'distance': distance,
        'distanceSquared': distanceSquared,
        'centroidsConverged': centroidsConverged,
        'assignmentsConverged': assignmentsConverged,
        "assignmentsToClusters": assignmentsToClusters
    };

});

/**
 * kmeans++ initialization module
 */
define(function (require) {
    "use strict";

    const kmeans = require("./kmeans");

    /**
     * @public
     * create an initial model given the data and the number of clusters.
     *
     * This uses the kmeans++ algorithm:
     * 1. Choose one center uniformly at random from among the data points.
     * 2. For each data point x, compute D(x), the distance between x and
     *    the nearest center that has already been chosen.
     * 3. Choose one new data point at random as a new center,
     *    using a weighted probability distribution where a point x is chosen with probability proportional to D(x)^2.
     * 4. Repeat Steps 2 and 3 until k centers have been chosen.
     * 5. Now that the initial centers have been chosen, proceed using
     *    standard k-means clustering.
     *
     * @param {[float]} observations the data as an array of number
     * @param {integer} k the number of clusters
     */
    return function(observations, k) {

        /**
         * given a set of n  weights,
         * choose a value in the range 0..n-1
         * at random using weights as a distribution.
         *
         * @param {*} weights
         */
        function weightedRandomIndex(weights, normalizationWeight) {
            const n = weights.length;
            if(typeof normalizationWeight !== 'number') {
                normalizationWeight = 0.0;
                for(let i = 0; i < n; i += 1) {
                    normalizationWeight += weights[i];
                }
            }

            const r = Math.random();  // uniformly random number 0..1 (a probability)
            let index = 0;
            let cumulativeWeight = 0.0;
            for(let i = 0; i < n; i += 1) {
                //
                // use the uniform probability to search
                // within the normalized weighting (we divide by totalWeight to normalize).
                // once we hit the probability, we have found our index.
                //
                cumulativeWeight += weights[i] / normalizationWeight;
                if(cumulativeWeight > r) {
                    return i;
                }
            }

            throw Error("algorithmic failure choosing weighted random index");
        }

        const n = observations.length;
        const distanceToCloseCentroid = []; // distance D(x) to closest centroid for each observation
        const centroids = [];   // indices of observations that are chosen as centroids

        //
        // keep list of all observations' indices so
        // we can remove centroids as they are created
        // so they can't be chosen twice
        //
        const index = [];
        for(let i = 0; i < n; i += 1) {
            index[i] = i;
        }

        //
        //  1. Choose one center uniformly at random from among the data points.
        //
        let centroidIndex = Math.floor(Math.random() * n);
        centroids.push(centroidIndex);

        for(let c = 1; c < k; c += 1) {
            index.slice(centroids[c - 1], 1);    // remove previous centroid from further consideration
            distanceToCloseCentroid[centroids[c - 1]] = 0;  // this effectively removes it from the probability distribution

            //
            // 2. For each data point x, compute D(x), the distance between x and
            //    the nearest center that has already been chosen.
            //
            // NOTE: we used the distance squared (L2 norm)
            //
            let totalWeight = 0.0;
            for(let i = 0; i < index.length; i += 1) {
                //
                // if this is the first time through, the distance is undefined, so just set it.
                // Otherwise, choose the minimum of the prior closest and this new centroid
                //
                const distanceToCentroid = kmeans.distanceSquared(observations[index[i]], observations[centroids[c - 1]]);
                distanceToCloseCentroid[index[i]] =
                    (typeof distanceToCloseCentroid[index[i]] === 'number')
                    ? Math.min(distanceToCloseCentroid[index[i]], distanceToCentroid)
                    : distanceToCentroid;
                totalWeight += distanceToCloseCentroid[index[i]];
            }

            //
            //  3. Choose one new data point at random as a new center,
            //     using a weighted probability distribution where a point x is chosen with probability proportional to D(x)^2.
            //
            centroidIndex = index[weightedRandomIndex(distanceToCloseCentroid, totalWeight)];
            centroids.push(centroidIndex);

            //  4. Repeat Steps 2 and 3 until k centers have been chosen.
        }

        //
        //  5. Now that the initial centers have been chosen, proceed using
        //     standard k-means clustering. Return the model so that
        //     kmeans can continue.
        //
        return {
            'observations': observations,
            'centroids': centroids.map(x => observations[x]), // map centroid index to centroid value
            'assignments': observations.map((x, i) => i % centroids.length) // distribute among centroids
        }
    }

});

/**
 * Extra Credit #1
 * module for creating random models for kmeans clustering
 */
define(function (require) {
    "use strict";

    const kmeans = require("./kmeans");

    /**
     * @return a random, normally distributed number
     */
    function randomNormal() {
        // n = 6 gives a good enough approximation
        return ((Math.random() + Math.random() + Math.random() + Math.random() + Math.random() + Math.random()) - 3) / 3;
    }

    /**
     * Generate a uniform random unit vector
     *
     * @param {Integer} d dimension of data
     * @return n random datapoints of dimension d with length == 1
     */
    function randomUnitVector(d) {
        const range = max - min;
        let magnitude = 0.0;
        const observation = [];

        // uniform random for each dimension
        for(let j = 0; j < d; j += 1) {
            const x = Math.random();
            observation[j] = x;
            magnitude = x * x;
        }

        // normalize
        const magnitude = Math.sqrt(magnitude);
        for(let j = 0; j < d; j += 1) {
            observation[j] /= magnitude;
        }

        return observation;
    }

    /**
     * Generate a uniform random unit vectors for clustering
     *
     * @param {Integer} n number of data points
     * @param {Integer} d dimension of data
     * @return n random datapoints of dimension d with length == 1
     */
    function randomUnitVectors(n, d) {

        // create n random observations, each of dimension d
        const observations = [];
        for(let i = 0; i < n; i += 1) {
            // create random observation of dimension d
            const observation = randomUnitVector(d);
            observations.push(observation);
        }

        return observations;
    }



    /**
     * Generate a spherical random vector
     *
     * @param {Integer} n number of data points
     * @param {Integer} d dimension of data
     * @param {Number} r radium from center for data point
     * @return n random datapoints of dimension d
     */
    function randomSphericalVector(d, r) {
        const observation = [];

        let magnitude = 0.0;
        for(let j = 0; j < d; j += 1)
        {
            const x = randomNormal();
            observation[j] = x;
            magnitude += x * x;
        }

        // normalize
        magnitude = Math.sqrt(magnitude);
        for(let j = 0; j < d; j += 1) {
            observation[j] = observation[j] * r / magnitude;
        }

        return observation;
    }



    /**
     * Generate a spherical random vectors
     *
     * @param {Integer} n number of data points
     * @param {Integer} d dimension of data
     * @param {Number} max radius from center for data points
     * @return n random datapoints of dimension d
     */
    function randomSphericalVectors(n, d, r) {

        // create n random observations, each of dimension d
        const observations = [];
        for(let i = 0; i < n; i += 1) {
            // create random observation of dimension d with random radius
            const observation = randomSphericalVector(d, Math.random() * r);
            observations.push(observation);
        }

        return observations;
    }

    /**
     * Generate a uniform random model for clustering
     *
     * @param {Integer} n number of data points
     * @param {Integer} d dimension of data
     * @param {Number} radius of sphere
     * @return n random datapoints of dimension d
     */
    function randomVectors(n, d, min, max) {

        const range = max - min;

        // create n random observations, each of dimension d
        const observations = [];
        for(let i = 0; i < n; i += 1) {
            // create random observation of dimension d
            const observation = randomVector(d, min, max);
            observations.push(observation);
        }

        return observations;
    }

    /**
     * Generate a uniform random model for clustering
     *
     * @param {Integer} d dimension of data
     * @param {Number} radius of sphere
     * @return n random datapoints of dimension d
     */
    function randomVector(d, min, max) {

        // create random observation of dimension d
        const range = max - min;
        const observation = [];
        for(let j = 0; j < d; j += 1) {
            observation.push(min + Math.random() * range);
        }

        return observation;
    }

    return {
        'randomVector': randomVector,
        'randomUnitVector': randomUnitVector,
        'randomSphericalVector': randomSphericalVector,
        'randomVectors': randomVectors,
        'randomUnitVectors': randomUnitVectors,
        'randomSphericalVectors': randomSphericalVectors
    }

});

/**
 * Extra Credit #4
 * Application to cluster random data using kmeans++
 *
 * cluster(k, n, d) - cluster n data points of dimension d into k clusters
 * plot(canvas, result) - plot the results of cluster() to the given html5 canvas using clusterjs
 */
define(function (require) {
    "use strict";
    const kmeans = require("./kmeans/kmeans");
    const kmeanspp = require("./kmeans/kmeanspp");
    const randomCentroidInitializer = require("./kmeans/randomCentroidInitializer");
    const kmeansRandomModel = require("./kmeans/kmeansRandomModel");


    /**
     * @public
     * Load iris dataset and run kmeans on it given the number of clusters
     *
     * @param {integer} k number of clusters to create
     */
    function cluster(k, n, d) {

        //
        // map iris data rows from dictionary to vector (array), leaving out the label
        //
        const observations = kmeansRandomModel.randomSphericalVectors(n, d, 10.0);

        //
        // create the intial model and run it
        //
        // const initialModel = randomCentroidInitializer(observations, k);
        const initialModel = kmeanspp(observations, k);

        //
        // cluster into given number of clusters
        //
        const results = kmeans.cluster(initialModel);

        //
        // do this for the convenience of the plotting functions
        //
        results.clusters = kmeans.assignmentsToClusters(results.model);

        return results;
    }

    const clusterColor = ['red', 'green', 'blue', 'yellow', 'purple', 'cyan', 'magenta', 'pink', 'brown', 'black'];
    let chart = undefined;

    /**
     * plot the clustred iris data model.
     *
     * @param {object} results of cluster(), with model, clusters and clusterCompositions
     * @param {boolean} showClusterColor true to show learned cluster points
     * @param {boolean} showSpeciesColor true to show known dataset labelled points
     */
    function plot(canvas, results) {

        //
        // map iris data rows from dictionary to vector (array), leaving out the label
        //
        const model = results.model;
        const observations = model.observations;
        const assignments = model.assignments;
        const centroids = model.centroids;
        const d = observations[0].length;
        const n = observations.length;
        const k = centroids.length;

        //
        // put offset of each data points into clusters using the assignments
        //
        const clusters = results.clusters;

        //
        // plot the clusters
        //
        const chartData = {
            // for the purposes of plotting in 2 dimensions, we will use
            // x = dimension 0 and y = dimension 1
            datasets: clusters.map(function(c, i) {
                return {
                    label: "cluster" + i,
                    data: c.map(d => ({'x': observations[d][0], 'y': observations[d][1]})),
                    backgroundColor: clusterColor[i % clusterColor.length],
                    pointBackgroundColor: clusterColor[i % clusterColor.length],
                    pointBorderColor:  clusterColor[i % clusterColor.length]
                };
            })
        };
        const chartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            title: {
                display: true,
                text: 'Random spherical data set (d=$d, n=$n) clustered using K-Means (k=$k)'
                        .replace("$d", d)
                        .replace('$n', n)
                        .replace('$k', k)
            },
            legend: {
                position: 'bottom',
                display: true
            },
            scales: {
                xAxes: [{
                    type: 'linear',
                    position: 'bottom',
                    scaleLabel: {
                        labelString: 'x axis',
                        display: false,
                    }
                }],
                yAxes: [{
                    type: 'linear',
                    position: 'left',
                    scaleLabel: {
                        labelString: 'y axis',
                        display: false
                    }
                }]
            }
        };

        //
        // we need to destroy the previous chart so it's interactivity
        // does not continue to run
        //
        if(undefined !== chart) {
            chart.destroy()
        }
        chart = new Chart(canvas, {
            type: 'scatter',
            data: chartData,
            options: chartOptions,
        });

    }

    return {'cluster': cluster, 'plot': plot};
});

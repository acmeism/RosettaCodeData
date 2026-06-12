import java.util.Scanner;
import java.util.Arrays; // For printing arrays easily

class BankerAlgorithm {

    public static void main(String[] args) {
        // Use try-with-resources to ensure the scanner is closed automatically
        try (Scanner scanner = new Scanner(System.in)) {

            // 1. Read Input Sizes
            System.out.print("Number of resources: ");
            int resources = scanner.nextInt();
            System.out.print("Number of processes: ");
            int processes = scanner.nextInt();
            scanner.nextLine(); // Consume the newline left-over from nextInt()

            // 2. Read Maximum Resources
            System.out.print("Maximum resources (space-separated): ");
            int[] maxResources = new int[resources];
            String[] maxResParts = scanner.nextLine().trim().split("\\s+");
            for (int i = 0; i < resources; i++) {
                maxResources[i] = Integer.parseInt(maxResParts[i]);
            }

            // 3. Read Currently Allocated Resources for each process
            int[][] currentlyAllocated = new int[processes][resources];
            System.out.println("\n-- resources allocated for each process --");
            for (int i = 0; i < processes; i++) {
                System.out.print("process " + (i + 1) + ": ");
                String[] allocatedParts = scanner.nextLine().trim().split("\\s+");
                for (int j = 0; j < resources; j++) {
                    currentlyAllocated[i][j] = Integer.parseInt(allocatedParts[j]);
                }
            }

            // 4. Read Maximum Need for each process
            int[][] maxNeed = new int[processes][resources];
            System.out.println("\n--- maximum resources for each process ---");
            for (int i = 0; i < processes; i++) {
                System.out.print("process " + (i + 1) + ": ");
                String[] maxNeedParts = scanner.nextLine().trim().split("\\s+");
                for (int j = 0; j < resources; j++) {
                    maxNeed[i][j] = Integer.parseInt(maxNeedParts[j]);
                }
            }

            // 5. Calculate Total Allocated Resources
            int[] allocated = new int[resources]; // Initialized to 0 by default
            for (int i = 0; i < processes; i++) {
                for (int j = 0; j < resources; j++) {
                    allocated[j] += currentlyAllocated[i][j];
                }
            }
            System.out.println("\nTotal resources allocated: " + Arrays.toString(allocated));

            // 6. Calculate Available Resources
            int[] available = new int[resources];
            for (int i = 0; i < resources; i++) {
                available[i] = maxResources[i] - allocated[i];
                // Optional check for negative available resources (indicates input error)
                if (available[i] < 0) {
                     System.err.println("Error: Calculated available resources are negative for resource " + i + ". Check input consistency.");
                     return; // Exit if input is inconsistent
                }
            }
            System.out.println("Total resources available: " + Arrays.toString(available) + "\n");

            // 7. Banker's Algorithm (Safety Check)
            boolean[] running = new boolean[processes];
            Arrays.fill(running, true); // Initially, all processes are running (haven't finished)
            int count = processes; // Number of processes still needing to run

            while (count > 0) { // While there are still processes that haven't finished
                boolean safe = false; // Flag to check if we found at least one process to run in this pass

                for (int i = 0; i < processes; i++) {
                    if (running[i]) { // Check only processes that are still marked as running
                        boolean canExecute = true;
                        // Check if the process's *remaining need* can be satisfied by *available* resources
                        for (int j = 0; j < resources; j++) {
                            int needed = maxNeed[i][j] - currentlyAllocated[i][j];
                            if (needed > available[j]) {
                                canExecute = false; // Cannot execute, not enough resources
                                break; // No need to check further resources for this process
                            }
                        }

                        if (canExecute) {
                            // Process can execute!
                            System.out.println("process " + (i + 1) + " running");
                            running[i] = false; // Mark process as finished
                            count--;            // Decrement count of running processes
                            safe = true;        // Found a safe process in this pass

                            // Release the resources allocated to this process
                            for (int j = 0; j < resources; j++) {
                                available[j] += currentlyAllocated[i][j];
                            }

                            // Optional: Print intermediate state (as in Python code)
                            // Note: The Python code prints this *after* the process loop if safe was true.
                            // Moved the print statement outside this inner 'if' but inside the 'while'.

                            break; // Found a process, restart the check from the beginning
                                   // (or from the next process, depending on Banker's variant,
                                   // but breaking and restarting the outer loop is common and matches Python logic)
                        }
                    }
                } // End of loop through processes

                if (!safe) {
                    // If we went through all running processes and couldn't find one to execute
                    System.out.println("The process is in an unsafe state.");
                    break; // Exit the while loop, deadlock detected or unsafe state
                } else {
                     // If we *did* find a safe process (safe == true), print the state and continue the while loop
                     System.out.println("The process is in a safe state."); // As per Python code structure
                     System.out.println("Available resources: " + Arrays.toString(available) + "\n");
                }
            } // End of while loop

            // Final check after the loop finishes
            if (count == 0) {
                // If count is 0, all processes finished successfully
                System.out.println("\nAll processes finished successfully. The initial state was safe.");
            }

        } catch (NumberFormatException e) {
            System.err.println("Error: Invalid number format entered. Please enter integers only.");
            e.printStackTrace();
        } catch (ArrayIndexOutOfBoundsException e) {
             System.err.println("Error: Incorrect number of values entered on a line.");
             e.printStackTrace();
        } catch (Exception e) {
            // Catch any other potential exceptions during input or processing
            System.err.println("An unexpected error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

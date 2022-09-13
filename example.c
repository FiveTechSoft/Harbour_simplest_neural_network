#include <stdio.h>
#include <stdlib.h>

#define INPUT_SIZE 2
#define HIDDEN_SIZE 2
#define OUTPUT_SIZE 1

#define LEARNING_RATE 0.1

int main(int argc, char** argv) {
	// input layer
	double input[INPUT_SIZE];
	// hidden layer
	double hidden[HIDDEN_SIZE];
	// output layer
	double output;

	// weights
	double wih[INPUT_SIZE][HIDDEN_SIZE];
	double who[HIDDEN_SIZE];

	// initialize weights
	for(int i = 0; i < INPUT_SIZE; i++) {
		for(int j = 0; j < HIDDEN_SIZE; j++) {
			wih[i][j] = ((double)rand() / RAND_MAX) * 2 - 1;
		}
	}

	for(int i = 0; i < HIDDEN_SIZE; i++) {
		who[i] = ((double)rand() / RAND_MAX) * 2 - 1;
	}

	// training data
	double XOR[4][3] = {
		{0, 0, 0},
		{0, 1, 1},
		{1, 0, 1},
		{1, 1, 0}
	};

	// main loop
	for(int i = 0; i < 40000; i++) {
		// pick a random training example
		int n = rand() % 4;

		// set input layer to the corresponding training example
		input[0] = XOR[n][0];
		input[1] = XOR[n][1];

		// feed forward
		for(int j = 0; j < HIDDEN_SIZE; j++) {
			hidden[j] = 0;
			for(int k = 0; k < INPUT_SIZE; k++) {
				hidden[j] += input[k] * wih[k][j];
			}
			hidden[j] = 1 / (1 + exp(-hidden[j]));
		}

		output = 0;
		for(int j = 0; j < HIDDEN_SIZE; j++) {
			output += hidden[j] * who[j];
		}
		output = 1 / (1 + exp(-output));

		// backpropagation
		double error = XOR[n][2] - output;
		double delta = error * output * (1 - output);

		for(int j = 0; j < HIDDEN_SIZE; j++) {
			who[j] += LEARNING_RATE * hidden[j] * delta;
		}

		for(int j = 0; j < HIDDEN_SIZE; j++) {
			double h_delta = delta * who[j] * hidden[j] * (1 - hidden[j]);
			for(int k = 0; k < INPUT_SIZE; k++) {
				wih[k][j] += LEARNING_RATE * input[k] * h_delta;
			}
		}
	}

	// test
	for(int i = 0; i < 4; i++) {
		input[0] = XOR[i][0];
		input[1] = XOR[i][1];

		for(int j = 0; j < HIDDEN_SIZE; j++) {
			hidden[j] = 0;
			for(int k = 0; k < INPUT_SIZE; k++) {
				hidden[j] += input[k] * wih[k][j];
			}
			hidden[j] = 1 / (1 + exp(-hidden[j]));
		}

		output = 0;
		for(int j = 0; j < HIDDEN_SIZE; j++) {
			output += hidden[j] * who[j];
		}
		output = 1 / (1 + exp(-output));

		printf("%d XOR %d = %.2f\n", (int)XOR[i][0], (int)XOR[i][1], output);
	}

	return 0;
}
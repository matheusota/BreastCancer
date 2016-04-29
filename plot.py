import matplotlib.pyplot as plt

plt.semilogx([1, 10, 100, 1000, 10000], [0.9068, 0.9332, 0.94198, 0.94201, 0.94201], '-o')
plt.ylabel('Accuracy')
plt.xlabel('Number of Decision Trees')
plt.show()

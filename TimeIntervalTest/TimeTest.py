import matplotlib.pyplot as plt
import numpy as np

FG = []
BG = []
BG_to_FG = []
y_FG = []
y_BG = []
y_BG_to_FG = []
flag = 0

with open("2020_06_24_19_38_38.txt") as f:
    for line in f:
        eles = line.split()

        if eles[0] == "Sampling" or eles[0] == "timestamp":
            continue
        
        if len(eles) == 1:
            if eles[0] == "Background":
                flag = 1
            else:
                flag = 2
            continue

        if flag == 0:
            FG.append(int(eles[0]))
        elif flag == 1:
            BG.append(int(eles[0]))
        else:
            BG_to_FG.append(int(eles[0]))

for i in range(len(FG) - 1):
    y_FG.append(FG[i + 1] - FG[i])

for i in range(len(BG) - 1):
    y_BG.append(BG[i + 1] - BG[i])

for i in range(len(BG_to_FG) - 1):
    y_BG_to_FG.append(BG_to_FG[i + 1] - BG_to_FG[i])



x_FG = list(range(len(y_FG)))
x_BG = list(range(len(y_FG), len(y_FG) + len(y_BG)))
x_BG_to_FG = list(range(len(y_FG) + len(y_BG), len(y_FG) + len(y_BG) + len(y_BG_to_FG)))

plt.plot(x_FG, y_FG, "r")
plt.plot(x_BG, y_BG, "g")
plt.plot(x_BG_to_FG, y_BG_to_FG, "b")
plt.xlabel("Sample Count (r: FG, g: BG, b: BG to FG)")
plt.ylabel("Time Interval (ms)")
plt.show()


# data = np.loadtxt("2020_06_21_15_30_20.txt")

# x = data[:, 0]
# y_plot = []

# # for i in range(len(x) - 1):
# #     y_plot.append(x[i + 1] - x[i])

# # x_plot = list(range(len(y_plot)))

# # plt.plot(x_plot, y_plot)
# # plt.show()

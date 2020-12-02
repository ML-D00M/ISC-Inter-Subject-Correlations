import matplotlib.pyplot as plt
import numpy as np


def plot_isc(isc_all):
    # plot ISC as a bar chart
    plt.figure()
    comp1 = [cond['ISC'][0] for cond in isc_all.values()]
    comp2 = [cond['ISC'][1] for cond in isc_all.values()]
    comp3 = [cond['ISC'][2] for cond in isc_all.values()]
    barWidth = 0.2
    r1 = np.arange(len(comp1))
    r2 = [x + barWidth for x in r1]
    r3 = [x + barWidth for x in r2]
    plt.bar(r1, comp1, color='gray', width=barWidth, edgecolor='white', label='Comp1')
    plt.bar(r2, comp2, color='green', width=barWidth, edgecolor='white', label='Comp2')
    plt.bar(r3, comp3, color='green', width=barWidth, edgecolor='white', label='Comp3')
    plt.xticks([r + barWidth for r in range(len(comp1))], isc_all.keys())
    plt.ylabel('ISC', fontweight='bold')
    plt.title('ISC for each condition')
    plt.legend()
    plt.show()

    # plot ISC_persecond
    for cond in isc_all.values():
        for comp_i in range(0, 3):
            plt.subplot(3, 1, comp_i+1)
            plt.plot(cond['ISC_persecond'][comp_i])
            plt.legend(isc_all.keys())
            plt.xlabel('Time (s)')
            plt.ylabel('ISC')
            #plt.title('ISC per second for each condition')


    # plot ISC_bysubject
    # fig, ax = plt.subplots()
    # ax.set_title('ISC by subject for each condition')
    # a = [cond['ISC_bysubject'][0, :] for cond in isc_all.values()]
    # ax.set_xticklabels(isc_all.keys())
    # ax.set_ylabel('ISC')
    # ax.set_xlabel('Conditions', fontweight='bold')
    # ax.boxplot(a)

    # # MAKE WITH DOTS:
    # for i in [1, 2]:
    #     y = [isc_results['Gr1']['ISC_bysubject'][0], isc_results['Gr1']['ISC_bysubject'][0]][i - 1]
    #     x = np.random.normal(i, 0.02, len(y))
    #     plt.plot(x, y, 'r.', alpha=0.9, color='black', markersize=12)

plot_isc(isc_results)
sign = [pseudo_grs_difference_c1_095]

for cond in isc_results.values():
    for comp_i in range(0, 1):
        plt.subplot(3, 1, comp_i + 1)
        plt.plot(cond['ISC_persecond'][comp_i])
        sign = cond['ISC_persecond'][comp_i] > 0.1
        #t = np.where(cond['ISC_persecond'][comp_i] > 0.1)
        t = np.where(cond['ISC_persecond'][comp_i][sign])
        plt.plot(np.transpose(t), cond['ISC_persecond'][comp_i][sign], 'x', color='k')
        #plt.fill_between(list(range(0, 176)), 0, 0.1, facecolor='gray')
        plt.legend([list(isc_results.keys())[0]] + ['Significant'] + [list(isc_results.keys())[1]])
        plt.xlabel('Time (s)')
        plt.ylabel('ISC')


### FOR comp=1

plot_isc(isc_results)

sign = pseudo_grs_difference_c1_095
comp_i = 0
plt.figure()

for cond in isc_results.values():
    plt.subplot(3, 1, 1)
    plt.plot(cond['ISC_persecond'][comp_i])

    t = [i for i, x in enumerate(pseudo_grs_difference_c1_095) if x]
    plt.plot(np.transpose(t), cond['ISC_persecond'][comp_i][sign], 'x', color='k')

    #plt.legend([list(isc_results.keys())[0]] + ['Significant'] + [list(isc_results.keys())[1]])
    plt.xlabel('Time (s)')
    plt.ylabel('ISC')

plt.figure()
plt.plot(np.mean(pseudo_gr1_all_shuffles, 0))
plt.plot(np.mean(pseudo_gr2_all_shuffles, 0))

plt.figure()
for shuffle in range(0, 48):
    plt.plot(pseudo_gr1_all_shuffles[shuffle, :])


plt.figure()
for shuffle in range(0, 48):
    plt.plot(pseudo_gr2_all_shuffles[shuffle, :])






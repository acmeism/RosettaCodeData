my %vs = (
    options => [<Rock Paper Scissors Lizard Spock>],
    ro => {
        ro => [ 2, ''                            ],
        pa => [ 1, 'Paper covers Rock: '         ],
        sc => [ 0, 'Rock smashes Scissors: '     ],
        li => [ 0, 'Rock crushes Lizard: '       ],
        sp => [ 1, 'Spock vaporizes Rock: '      ]
    },
    pa => {
        ro => [ 0, 'Paper covers Rock: '         ],
        pa => [ 2, ''                            ],
        sc => [ 1, 'Scissors cut Paper: '        ],
        li => [ 1, 'Lizard eats Paper: '         ],
        sp => [ 0, 'Paper disproves Spock: '     ]
    },
    sc => {
        ro => [ 1, 'Rock smashes Scissors: '     ],
        pa => [ 0, 'Scissors cut Paper: '        ],
        sc => [ 2, ''                            ],
        li => [ 0, 'Scissors decapitate Lizard: '],
        sp => [ 1, 'Spock smashes Scissors: '    ]
    },
    li => {
        ro => [ 1, 'Rock crushes Lizard: '       ],
        pa => [ 0, 'Lizard eats Paper: '         ],
        sc => [ 1, 'Scissors decapitate Lizard: '],
        li => [ 2, ''                            ],
        sp => [ 0, 'Lizard poisons Spock: '      ]
    },
    sp => {
        ro => [ 0, 'Spock vaporizes Rock: '      ],
        pa => [ 1, 'Paper disproves Spock: '     ],
        sc => [ 0, 'Spock smashes Scissors: '    ],
        li => [ 1, 'Lizard poisons Spock: '      ],
        sp => [ 2, ''                            ]
    }
);

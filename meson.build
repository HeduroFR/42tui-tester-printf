project('printf_tester', ['c', 'vala', 'nasm'])


dependencies = [
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  dependency('gmodule-2.0'),
  # printf
]
executable('printf_tester',
  'main.vala',
  'finder_project.vala',
  'SupraLeak.vala', 
  'SupraTest.vala',
  'PrintTester.vala',
  'BonusTest.vala',
  'leak.c',
  'test.asm',
  vala_args: '--pkg=posix',
  c_args: '-w',
  dependencies: dependencies,
  install: true
)

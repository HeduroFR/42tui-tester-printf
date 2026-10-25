project('printf_tester', ['c', 'vala', 'nasm'])


cc = meson.get_compiler('c')
# TODO temporary
lib_dir = meson.current_source_dir() + ''
printf = cc.find_library('ftprintf',
  dirs: lib_dir
)

dependencies = [
  dependency('glib-2.0'),
  dependency('gio-2.0'),
  dependency('gmodule-2.0'),
  # printf
]
executable('printf_tester',
  'main.vala', 
  'SupraLeak.vala', 
  'SupraTest.vala',
  'PrintTester.vala',
  'leak.c',
  'test.asm',
  vala_args: '--pkg=posix',
  c_args: '-w',
  dependencies: dependencies,
  install: true
)

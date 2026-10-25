#ifndef TEST_MACRO_H
# define TEST_MACRO_H

void test_impl(const char *src, const char *fmt, ...);

# define TEST(fmt, ...) test_impl(#fmt ", " #__VA_ARGS__, fmt, ##__VA_ARGS__)

#endif

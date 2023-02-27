#include "assert.h"
#include "matx.h"
#include "test_types.h"
#include "utilities.h"
#include "gtest/gtest.h"

using namespace matx;


TEST(MatMulTests, SmallRectATransposeDouble)
{
  MATX_ENTER_HANDLER();
  using TypeParam = double;

  constexpr index_t m = 4;
  constexpr index_t k = 8;
  constexpr index_t n = 16;
  tensor_t<TypeParam, 2> a{{k, m}};
  tensor_t<TypeParam, 2> b{{k, n}};
  tensor_t<TypeParam, 2> c{{m, n}};

  auto pb = std::make_unique<detail::MatXPybind>(); 
  constexpr float thresh = (is_complex_half_v<TypeParam> || is_matx_half_v<TypeParam>) ? 0.5f : 0.1f;  

  pb->template InitAndRunTVGenerator<TypeParam>(
      "00_transforms", "matmul_operators", "run", {m, k, n});

  pb->NumpyToTensorView(a, "a");
  pb->NumpyToTensorView(b, "b");

  auto at = a.PermuteMatrix();
  matmul(c, at, b);
  MATX_TEST_ASSERT_COMPARE(pb, c, "c", thresh);

  MATX_EXIT_HANDLER();
}

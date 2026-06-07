import 'package:get/get.dart';
import '../network/http_client.dart';
import '../network/network_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/presentation/controllers/users_controller.dart';
import '../../features/users/presentation/controllers/user_details_controller.dart';
import '../../features/sellers/data/repositories/seller_repository_impl.dart';
import '../../features/sellers/domain/repositories/seller_repository.dart';
import '../../features/sellers/presentation/controllers/sellers_controller.dart';
import '../../features/sellers/presentation/controllers/seller_details_controller.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/presentation/controllers/products_controller.dart';
import '../../features/products/presentation/controllers/product_details_controller.dart';
import '../../features/reports/data/repositories/report_repository_impl.dart';
import '../../features/reports/domain/repositories/report_repository.dart';
import '../../features/reports/presentation/controllers/reports_controller.dart';
import '../../features/reports/presentation/controllers/report_details_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    final httpClient = HttpClient();
    Get.put<HttpClient>(httpClient, permanent: true);
    final networkService = NetworkService(httpClient.instance);
    Get.put<NetworkService>(networkService, permanent: true);

    // Auth
    final authRepository = AuthRepositoryImpl(networkService);
    Get.put<AuthRepository>(authRepository, permanent: true);
    Get.put<AuthController>(AuthController(authRepository), permanent: true);

    // Dashboard
    final dashboardRepository = DashboardRepositoryImpl(networkService);
    Get.put<DashboardRepository>(dashboardRepository, permanent: true);
    Get.put<DashboardController>(DashboardController(dashboardRepository), permanent: true);

    // Users
    final userRepository = UserRepositoryImpl(networkService);
    Get.put<UserRepository>(userRepository, permanent: true);
    Get.put<UsersController>(UsersController(userRepository), permanent: true);
    Get.put<UserDetailsController>(UserDetailsController(userRepository), permanent: true);

    // Sellers
    final sellerRepository = SellerRepositoryImpl(networkService);
    Get.put<SellerRepository>(sellerRepository, permanent: true);
    Get.put<SellersController>(SellersController(sellerRepository), permanent: true);
    Get.put<SellerDetailsController>(SellerDetailsController(sellerRepository), permanent: true);

    // Products
    final productRepository = ProductRepositoryImpl(networkService);
    Get.put<ProductRepository>(productRepository, permanent: true);
    Get.put<ProductsController>(ProductsController(productRepository), permanent: true);
    Get.put<ProductDetailsController>(ProductDetailsController(productRepository), permanent: true);

    // Reports
    final reportRepository = ReportRepositoryImpl(networkService);
    Get.put<ReportRepository>(reportRepository, permanent: true);
    Get.put<ReportsController>(ReportsController(reportRepository), permanent: true);
    Get.put<ReportDetailsController>(ReportDetailsController(reportRepository), permanent: true);
  }
}

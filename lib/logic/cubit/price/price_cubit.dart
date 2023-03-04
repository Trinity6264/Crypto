import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:crypto/model/price_model.dart';
import 'package:crypto/repository/api_repo.dart';
import 'package:equatable/equatable.dart';

part 'price_state.dart';

class PriceCubit extends Cubit<PriceState> {
  final ApiRepo apiRepo;
  PriceCubit({required this.apiRepo}) : super(PriceInitial());

  Future<void> getPriceDetails({
     required String fiatCurrency,
    required String cryptoCurrency,
    required String paymentMethod,
    required String amount,
    required String network,
  }) async {
    try {
      emit(PriceLoading());
      final res = await apiRepo.getPriceDetail(
        amount: amount,
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fiatCurrency,
        network: network,
        paymentMethod: paymentMethod
      );
      if (res != null) {
        log('workgggg');
      }
    } on SocketException catch (_) {
      emit(const PriceFailure(
          errorMessage: 'Connection error,check your internet connection '));
    } on TimeoutException catch (_) {
      emit(const PriceFailure(
          errorMessage: 'Timeout,check your internet connection '));
    } on HandshakeException catch (e) {
      log(e.toString());
      emit(
        const PriceFailure(
            errorMessage: 'Something happened, Sorry try again 🥳'),
      );
    } catch (e) {
      log(e.runtimeType.toString());
      emit(
        const PriceFailure(
            errorMessage: 'Something happened, Sorry try again 🥳'),
      );
    }
  }
}

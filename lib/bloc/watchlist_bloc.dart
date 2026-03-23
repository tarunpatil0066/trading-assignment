import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/stockmodel.dart';

abstract class WatchlistEvent {}
class LoadWatchlist extends WatchlistEvent {}
abstract class WatchlistState {}
class WatchlistInitial extends WatchlistState {}
class WatchlistLoading extends WatchlistState {}
class WatchlistLoaded extends WatchlistState {
  final List<Stock> stocks;
  WatchlistLoaded(this.stocks);
}
class WatchlistError extends WatchlistState {
  final String message;
  WatchlistError(this.message);
}


class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {


  WatchlistBloc() : super(WatchlistInitial()) {
    on<LoadWatchlist>((event, emit) async {
      emit(WatchlistLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        final mockStocks = [
          Stock(symbol: "RELIANCE", description: "NSE | EQ", price: 1374.00, changeValue: -4.50, changePercentage: -0.33, isPositive: false),
          Stock(symbol: "HDFCBANK", description: "NSE | EQ", price: 966.85, changeValue: 0.85, changePercentage: 0.09, isPositive: true),
          Stock(symbol: "ASIANPAINT", description: "NSE | EQ", price: 966.85, changeValue: 0.85, changePercentage: 0.09, isPositive: true),
          Stock(symbol: "RELIANCE SEP 1880 CE", description: "NSE | EQ", price: 966.85, changeValue: 0.85, changePercentage: 0.09, isPositive: true),
          Stock(symbol: "RELIANCE", description: "NSE | EQ", price: 966.85, changeValue: 0.85, changePercentage: 0.09, isPositive: true),
          Stock(symbol: "NIFTY IT", description: "NSE | EQ", price: 966.85, changeValue: 0.85, changePercentage: 0.09, isPositive: true),
          Stock(symbol: "MRF", description: "NSE | EQ", price: 966.85, changeValue: 0.85, changePercentage: 0.09, isPositive: true),
        ];

        emit(WatchlistLoaded(mockStocks));
      } catch (e) {
        emit(WatchlistError("Failed to load stocks"));
      }
    });
    on<DeleteStock>((event, emit) {
      if (state is WatchlistLoaded) {
        final List<Stock> updatedList = List.from((state as WatchlistLoaded).stocks);
        updatedList.removeAt(event.index);
        emit(WatchlistLoaded(updatedList));
      }
    });

    on<ReorderStock>((event, emit) {
      if (state is WatchlistLoaded) {
        final List<Stock> updatedList = List.from((state as WatchlistLoaded).stocks);
        int newIdx = event.newIndex;
        if (event.oldIndex < newIdx) newIdx -= 1;
        final item = updatedList.removeAt(event.oldIndex);
        updatedList.insert(newIdx, item);
        emit(WatchlistLoaded(updatedList));
      }
    });
  }
}

class DeleteStock extends WatchlistEvent {
  final int index;
  DeleteStock(this.index);
}

class ReorderStock extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;
  ReorderStock(this.oldIndex, this.newIndex);
}

// Inside WatchlistBloc constructor, add the logic:




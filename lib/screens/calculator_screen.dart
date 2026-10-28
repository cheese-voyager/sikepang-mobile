import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../widgets/confirmation_dialog.dart';

/// Halaman Kalkulator Pertanian dan Perhitungan Pangan
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_shouldResetDisplay || _expression == '0') {
        _expression = digit;
        _shouldResetDisplay = false;
      } else {
        _expression += digit;
      }
      _calculateCurrentResult();
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_expression.isNotEmpty) {
        if (_operator != null && !_shouldResetDisplay) {
          _computeEqual();
        }
        _firstOperand = double.tryParse(_result);
        _operator = op;
        _shouldResetDisplay = true;
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (_shouldResetDisplay) {
        _expression = '0.';
        _shouldResetDisplay = false;
      } else if (!_expression.contains('.')) {
        _expression = _expression.isEmpty ? '0.' : '$_expression.';
      }
      _calculateCurrentResult();
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (_expression.isNotEmpty && !_shouldResetDisplay) {
        _expression = _expression.substring(0, _expression.length - 1);
        if (_expression.isEmpty) {
          _result = '0';
        } else {
          _calculateCurrentResult();
        }
      }
    });
  }

  void _calculateCurrentResult() {
    final currentVal = double.tryParse(_expression);
    if (currentVal == null) return;

    if (_firstOperand != null && _operator != null) {
      double res = 0;
      switch (_operator) {
        case '+':
          res = _firstOperand! + currentVal;
          break;
        case '-':
          res = _firstOperand! - currentVal;
          break;
        case '×':
          res = _firstOperand! * currentVal;
          break;
        case '÷':
          if (currentVal != 0) {
            res = _firstOperand! / currentVal;
          } else {
            _result = 'Error';
            return;
          }
          break;
      }
      _result = _formatNumber(res);
    } else {
      _result = _formatNumber(currentVal);
    }
  }

  void _computeEqual() {
    setState(() {
      if (_firstOperand != null && _operator != null) {
        final secondVal = double.tryParse(_expression) ?? 0;
        double res = 0;
        switch (_operator) {
          case '+':
            res = _firstOperand! + secondVal;
            break;
          case '-':
            res = _firstOperand! - secondVal;
            break;
          case '×':
            res = _firstOperand! * secondVal;
            break;
          case '÷':
            if (secondVal != 0) {
              res = _firstOperand! / secondVal;
            } else {
              _result = 'Tak Terhingga';
              _firstOperand = null;
              _operator = null;
              return;
            }
            break;
        }
        _result = _formatNumber(res);
        _expression = _result;
        _firstOperand = null;
        _operator = null;
        _shouldResetDisplay = true;
      }
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final currentVal = double.tryParse(_expression) ?? 0;
      final res = currentVal / 100.0;
      _expression = _formatNumber(res);
      _result = _expression;
    });
  }

  Future<void> _onResetWithConfirmation() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Reset Kalkulator',
      message: 'Apakah Anda yakin ingin membersihkan seluruh layar perhitungan saat ini?',
      confirmText: 'Bersihkan',
      cancelText: 'Batal',
      icon: Icons.delete_sweep_rounded,
      iconColor: AppColors.danger,
      confirmButtonColor: AppColors.danger,
    );

    if (confirmed && mounted) {
      setState(() {
        _expression = '';
        _result = '0';
        _firstOperand = null;
        _operator = null;
        _shouldResetDisplay = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.plantation700,
          content: Text('Kalkulator berhasil direset ke nilai awal.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _convertUnit(double factor, String unitName) {
    final currentVal = double.tryParse(_result) ?? double.tryParse(_expression) ?? 0;
    final converted = currentVal * factor;
    setState(() {
      _result = _formatNumber(converted);
      _expression = _result;
      _shouldResetDisplay = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.plantation700,
        content: Text('Konversi ke $unitName: $_result $unitName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2);
  }

  Widget _buildCalcButton({
    required String label,
    required VoidCallback onTap,
    Color bgColor = Colors.white,
    Color textColor = AppColors.textPrimary,
    bool isOperator = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          elevation: isOperator ? 1 : 0.5,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Panen & Satuan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Reset Kalkulator',
            onPressed: _onResetWithConfirmation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Baris Tombol Konversi Satuan Pertanian
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.plantation50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text(
                    'Konversi Kilogram:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.plantation900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('Kg ke Kuintal (÷100)'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.plantation300),
                    labelStyle: const TextStyle(fontSize: 11, color: AppColors.plantation800),
                    onPressed: () => _convertUnit(0.01, 'Kuintal'),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('Kg ke Ton (÷1000)'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.plantation300),
                    labelStyle: const TextStyle(fontSize: 11, color: AppColors.plantation800),
                    onPressed: () => _convertUnit(0.001, 'Ton'),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('Kuintal ke Kg (×100)'),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.plantation300),
                    labelStyle: const TextStyle(fontSize: 11, color: AppColors.plantation800),
                    onPressed: () => _convertUnit(100, 'Kg'),
                  ),
                ],
              ),
            ),
          ),

          // Area Tampilan Layar Kalkulator
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              alignment: Alignment.bottomRight,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _operator != null && _firstOperand != null
                        ? '${_formatNumber(_firstOperand!)} $_operator ${_expression.isEmpty ? '' : _expression}'
                        : _expression,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: AppColors.plantation900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Area Papan Tombol Kalkulator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            color: AppColors.background,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildCalcButton(
                      label: 'C',
                      onTap: _onResetWithConfirmation,
                      bgColor: const Color(0xFFFFE4E6),
                      textColor: AppColors.danger,
                    ),
                    _buildCalcButton(
                      label: '⌫',
                      onTap: _onBackspacePressed,
                      bgColor: AppColors.plantation100,
                      textColor: AppColors.plantation800,
                    ),
                    _buildCalcButton(
                      label: '%',
                      onTap: _onPercentagePressed,
                      bgColor: AppColors.plantation100,
                      textColor: AppColors.plantation800,
                    ),
                    _buildCalcButton(
                      label: '÷',
                      onTap: () => _onOperatorPressed('÷'),
                      bgColor: AppColors.plantation700,
                      textColor: Colors.white,
                      isOperator: true,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton(label: '7', onTap: () => _onDigitPressed('7')),
                    _buildCalcButton(label: '8', onTap: () => _onDigitPressed('8')),
                    _buildCalcButton(label: '9', onTap: () => _onDigitPressed('9')),
                    _buildCalcButton(
                      label: '×',
                      onTap: () => _onOperatorPressed('×'),
                      bgColor: AppColors.plantation700,
                      textColor: Colors.white,
                      isOperator: true,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton(label: '4', onTap: () => _onDigitPressed('4')),
                    _buildCalcButton(label: '5', onTap: () => _onDigitPressed('5')),
                    _buildCalcButton(label: '6', onTap: () => _onDigitPressed('6')),
                    _buildCalcButton(
                      label: '-',
                      onTap: () => _onOperatorPressed('-'),
                      bgColor: AppColors.plantation700,
                      textColor: Colors.white,
                      isOperator: true,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton(label: '1', onTap: () => _onDigitPressed('1')),
                    _buildCalcButton(label: '2', onTap: () => _onDigitPressed('2')),
                    _buildCalcButton(label: '3', onTap: () => _onDigitPressed('3')),
                    _buildCalcButton(
                      label: '+',
                      onTap: () => _onOperatorPressed('+'),
                      bgColor: AppColors.plantation700,
                      textColor: Colors.white,
                      isOperator: true,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton(label: '0', onTap: () => _onDigitPressed('0')),
                    _buildCalcButton(label: '00', onTap: () => _onDigitPressed('00')),
                    _buildCalcButton(label: '.', onTap: _onDecimalPressed),
                    _buildCalcButton(
                      label: '=',
                      onTap: _computeEqual,
                      bgColor: AppColors.leaf500,
                      textColor: Colors.white,
                      isOperator: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


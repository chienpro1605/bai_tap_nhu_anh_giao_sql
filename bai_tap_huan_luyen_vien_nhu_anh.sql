# BÀI TẬP ÔN TẬP SQL
# Bài quản lý sản phẩm
# 6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.
use demo2006;
select demo2006.order.id,demo2006.orderdetail.quantity*price as total
from demo2006.order join demo2006.orderdetail on (demo2006.order.id = demo2006.orderdetail.orderId)
join demo2006.product on (demo2006.orderdetail.productId = demo2006.product.id)
where time between '2006-6-19' and '2006-6-20' and demo2006.order.id = product.id;

# chualamdc 7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 6/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
select demo2006.order.id,sum(demo2006.orderdetail.quantity*price) as total
from demo2006.order join demo2006.orderdetail on (demo2006.order.id = demo2006.orderdetail.orderId)
join demo2006.product on (demo2006.orderdetail.productId = demo2006.product.id)
where time like '2006-06-%'
order by total desc;

# 8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 19/06/2006.
select demo2006.customer.id, demo2006.customer.name
from demo2006.customer, demo2006.order
where time = '2006-09-19'and demo2006.customer.id = demo2006.order.customerId;

#10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select demo2006.product.id, demo2006.product.name
from demo2006.product, demo2006.customer, demo2006.order
where demo2006.customer.name = 'Nguyen Van A' and time like '2006-10-%';

# 11. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.
select demo2006.orderdetail.orderId
from demo2006.orderdetail, demo2006.product
where (name = 'Máy giặt' or name = 'Tủ lạnh') and demo2006.product.id = demo2006.orderdetail.productId;

# 12. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select demo2006.orderdetail.orderId
from demo2006.orderdetail, demo2006.product
where (name = 'Máy giặt' or name = 'Tủ lạnh') and (demo2006.product.quantity between 10 and 20) and demo2006.product.id = demo2006.orderdetail.productId;

# 13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
use demo2006;
create view MayGiat as
select o.id, p.name, o.time
from demo2006.order o join orderdetail od on o.id = od.orderId
                       join product p on od.productId = p.id
where p.name like 'Máy giặt' and od.quantity between 10 and 20;

create view TuLanh as
select o.id, p.name, o.time
from demo2006.order o join orderdetail od on o.id = od.orderId
                       join product p on od.productId = p.id
where p.name like 'Tủ lạnh' and od.quantity between 10 and 20;
select MayGiat.id, MayGiat.time
from MayGiat join tulanh on MayGiat.id = tulanh.id;
# 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
select demo2006.product.name, demo2006.product.id
from demo2006.product
where demo2006.product.id not in (select productId from orderdetail);
# 16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
select product.Id,product.name
from product
where product.id not in (select productId from orderdetail,demo2006.order
where orderdetail.productId = product.id and year(time) = 2006);
# 17. In ra danh sách các sản phẩm (MASP,TENSP) có giá >300 sản xuất bán được trong năm 2006.
select p.Id, p.name
from (demo2006.order o, demo2006.product p) join demo2006.orderdetail od on o.id = od.orderId and p.id = od.productId
where p.price>300 and year(time) = 2006
group by p.id;

# 18. Tìm số hóa đơn đã mua tất cả các sản phẩm có giá >200.
select o.Id, p.name
from (demo2006.order o, demo2006.product p) join demo2006.orderdetail od on o.id = od.orderId and p.id = od.productId
where p.price>200
group by o.id;

# 19. Tìm số hóa đơn trong năm 2006 đã mua tất cả các sản phẩm có giá <300.
select o.id
from (demo2006.order o, demo2006.product p) join demo2006.orderdetail od on o.id = od.orderId and p.id = od.productId
where year(time) = 2006 and p.price<300
group by o.id;
# 21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
create view SPKHACNHAU AS
select p.id, p.name, o.time
from (demo2006.order o, demo2006.product p) join demo2006.orderdetail od on o.id = od.orderId and p.id = od.productId
where year(time) = 2006
group by p.id;
select count(SPKHACNHAU.id)
from SPKHACNHAU;

# 22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
create VIEW totalview as
select o.id,sum(p.price*od.quantity) as total, o.time, c.name, count(od.quantity)
from demo2006.customer c join demo2006.order o  join demo2006.orderdetail od join demo2006.product p on o.id = od.orderId and p.id = od.productId and o.customerId = c.id
group by o.id;
select max(totalview.total)
from totalview;

select min(totalview.total)
from totalview;

# 23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
select avg(totalview.total)
from totalview
where year(time) = 2006;
# 24. Tính doanh thu bán hàng trong năm 2006.
select sum(totalview.total)
from totalview
where year(time) = 2006;
# 25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
select max(totalview.total)
from totalview
where year(time) = 2006;

# 26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
select totalview.name 
from totalview
where totalview.total = (select max(totalview.total) from totalview);
# 27. In ra danh sách 3 khách hàng (MAKH, HOTEN) mua nhiều hàng nhất (tính theo số lượng).
select c.id, c.name, count(od.orderId) as solanmuahang
from demo2006.customer c join demo2006.order o  join demo2006.orderdetail od join demo2006.product p on o.id = od.orderId and p.id = od.productId and o.customerId = c.id
group by c.id
order by solanmuahang desc
limit 3;

# 28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
select p.id, p.name, p.price
from demo2006.product p 
order by p.price desc
limit 3;
# 29. In ra danh sách các sản phẩm (MASP, TENSP) có tên bắt đầu bằng chữ M, có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
select p.id, p.name, p.price
from demo2006.product p 
where p.name like 'M%'
order by p.price desc
limit 3;
# 32. Tính tổng số sản phẩm giá <300.
select p.name, count(p.price)
from product p
where p.price<300;
# 33. Tính tổng số sản phẩm theo từng giá.
select p.price, count(p.name)
from product p
group by p.price;
# 34. Tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm bắt đầu bằng chữ M.
select max(p.price) as max, min(p.price) as min, avg(p.price) as medium
from product p
where p.name like 'M%';

# 35. Tính doanh thu bán hàng mỗi ngày.
select totalview.total, totalview.time
from totalview
group by time;
# 36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
select p.name, sum(od.quantity) as tongsoluong
from product p join orderdetail od on p.id = od.productId
               join demo2006.order o on od.orderId = o.id
where year(time) = 2006 and month(time) = 10
group by p.id;

# 37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
select totalview.total,month(totalview.time) 
from totalview
where year(time) = 2006
group by month(time);
# 38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
select o.id
from demo2006.order o join demo2006.orderdetail od join demo2006.product p on od.productId = p.id and o.id = od.orderId
group by o.id
having count(od.productId)>=4;

# 39. Tìm hóa đơn có mua 3 sản phẩm có giá <300 (3 sản phẩm khác nhau).
create view spduoi300 as
select o.id, p.name, p.price
from demo2006.order o join demo2006.orderdetail od join demo2006.product p on od.productId = p.id and o.id = od.orderId
where p.price<300;
select spduoi300.id, count(spduoi300.id) as sosanphamduoi300
from spduoi300
group by spduoi300.id
having sosanphamduoi300>=3;

# 40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
create view solanmuamax as
select c.id, c.name, count(od.orderId) as solanmua
from demo2006.customer c join demo2006.order o join demo2006.orderdetail od on c.id = o.customerId and o.id = od.orderId
group by c.id;
select solanmuamax.id, solanmuamax.name, solanmuamax.solanmua
from solanmuamax
where solanmuamax.solanmua = (select max(solanmuamax.solanmua) from solanmuamax);


# 41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?
create view doanhsotheothang as
select totalview.time, totalview.total
from totalview
where year(time) = 2006
group by month(time);

select month(doanhsotheothang.time) , doanhsotheothang.total
from doanhsotheothang
where doanhsotheothang.total = (select max(doanhsotheothang.total) from doanhsotheothang);

# 42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
create view luongbansp2006 as
select p.id, p.name, sum(od.quantity) as sum
from demo2006.order o join demo2006.orderdetail od join demo2006.product p on od.productId = p.id and o.id = od.orderId
where year(time) = 2006
group by p.id;

select luongbansp2006.id, luongbansp2006.name, min(luongbansp2006.sum)
from luongbansp2006;

# 45. Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
create view doanhso as
select c.name, sum(p.price*od.quantity) as tong, count(od.orderId) as solanmua
from demo2006.customer c join demo2006.order o  join demo2006.orderdetail od join demo2006.product p on o.id = od.orderId and p.id = od.productId and o.customerId = c.id
group by o.customerId
order by tong desc
limit 10;
select *
from doanhso
where doanhso.solanmua = (select max(doanhso.solanmua) from doanhso);



